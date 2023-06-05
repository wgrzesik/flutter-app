import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/feature/data/remote/models/note_model.dart';
import 'package:note_app/feature/data/remote/models/user_model.dart';
import 'package:note_app/feature/domain/entities/stats_entity.dart';
import 'package:note_app/feature/domain/entities/user_entity.dart';
import 'package:note_app/feature/domain/entities/note_entity.dart';
import '../../../domain/entities/flashcard_entity.dart';
import 'package:note_app/feature/data/remote/models/flashcard_model.dart';
import '../../../domain/entities/set_entity.dart';
import 'package:note_app/feature/data/remote/models/set_model.dart';
import '../models/stats_model.dart';
import 'firebase_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseRemoteDataSourceImpl({required this.auth, required this.firestore});

  @override
  Future<void> addNewNote(NoteEntity noteEntity) async {
    final noteCollectionRef =
        firestore.collection("users").doc(noteEntity.uid).collection("notes");

    final noteId = noteCollectionRef.doc().id;

    noteCollectionRef.doc(noteId).get().then((note) {
      final newNote = NoteModel(
              uid: noteEntity.uid,
              noteId: noteId,
              note: noteEntity.note,
              time: noteEntity.time)
          .toDocument();

      if (!note.exists) {
        noteCollectionRef.doc(noteId).set(newNote);
      }
      return;
    });
  }

  @override
  Future<void> deleteNote(NoteEntity noteEntity) async {
    final noteCollectionRef =
        firestore.collection("users").doc(noteEntity.uid).collection("notes");

    noteCollectionRef.doc(noteEntity.noteId).get().then((note) {
      if (note.exists) {
        noteCollectionRef.doc(noteEntity.noteId).delete();
      }
      return;
    });
  }

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollectionRef = firestore.collection("user_data");
    final uid = await getCurrentUid();
    userCollectionRef.doc(user.uid).get().then((value) async {
      final newUser = UserModel(
        uid: uid,
        email: user.email,
        name: user.name,
      ).toDocument();

      if (!value.exists) {
        userCollectionRef.doc(uid).set(newUser);
      }
      return;
    });
  }

  @override
  Future<String> getCurrentUid() async => auth.currentUser!.uid;

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> signIn(UserEntity user) async => auth.signInWithEmailAndPassword(
      email: user.email!, password: user.password!);

  @override
  Future<void> signOut() async => auth.signOut();

  @override
  Future<void> signUp(UserEntity user) async =>
      auth.createUserWithEmailAndPassword(
          email: user.email!, password: user.password!);

  @override
  Future<void> updateNote(NoteEntity note) async {
    Map<String, dynamic> noteMap = Map();
    final noteCollectionRef =
        firestore.collection("users").doc(note.uid).collection("notes");

    if (note.note != null) noteMap['note'] = note.note;
    if (note.time != null) noteMap['time'] = note.time;

    noteCollectionRef.doc(note.noteId).update(noteMap);
  }

  @override
  Stream<List<NoteEntity>> getNotes(String uid) {
    final noteCollectionRef =
        firestore.collection("users").doc(uid).collection("notes");

    return noteCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => NoteModel.fromSnapshot(docSnap))
          .toList();
    });
  }

  @override
  Stream<List<SetEntity>> getSets() {
    final setCollectionRef = firestore.collection("sets");

    return setCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => SetModel.fromSnapshot(docSnap))
          .toList();
    });
  }

  @override
  Stream<List<FlashcardEntity>> getFlashcards(String uid) {
    final flashcardCollectionRef =
        firestore.collection("sets").doc(uid).collection("flashcards");

    return flashcardCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => FlashcardModel.fromSnapshot(docSnap))
          .toList();
    });
  }

  @override
  Future<void> initializeStats(String uid) async {
    final setCollectionRef = firestore.collection("sets");

    final setsStream = setCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => SetModel.fromSnapshot(docSnap))
          .toList();
    });

    setsStream.listen((List<SetEntity> sets) {
      for (SetEntity set in sets) {
        final flashcardCollectionRef =
            firestore.collection("sets").doc(set.name).collection("flashcards");

        final flashcardStream =
            flashcardCollectionRef.snapshots().map((querySnap) {
          return querySnap.docs
              .map((docSnap) => FlashcardModel.fromSnapshot(docSnap))
              .toList();
        });

        flashcardStream.listen((List<FlashcardEntity> flashcards) {
          for (FlashcardEntity flashcardEntity in flashcards) {
            final statsCollectionRef = firestore
                .collection("users")
                .doc(uid)
                .collection("sets")
                .doc(set.name)
                .collection("stats");

            final statsId = statsCollectionRef.doc().id;
            final newStats = StatsModel(
              uid: uid,
              set: set.name,
              term: flashcardEntity.term,
              amount: 0,
            ).toDocument();
            statsCollectionRef.doc(statsId).set(newStats);
          }
        });
      }
    });
  }

  @override
  Stream<List<StatsEntity>> srs(String uid, String setName) {
    final srsStreamController = StreamController<List<StatsEntity>>();
    List<StatsEntity> listOfStatsEntity = [];

    final srsCollectionRef = firestore
        .collection("users")
        .doc(uid)
        .collection("sets")
        .doc(setName)
        .collection("stats");

    final srsStream = srsCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => StatsModel.fromSnapshot(docSnap))
          .toList();
    });

    srsStream.listen((List<StatsEntity> stats) {
      if (stats.isEmpty) {
        srsStreamController.add(listOfStatsEntity);
        return;
      }

      stats.sort((a, b) => b.amount!.compareTo(a.amount!));
      final highestAmount = stats.first.amount!;
      final flashcardsList = List<List<StatsEntity>>.filled(
        highestAmount + 1,
        [],
        growable: false,
      );

      for (StatsEntity statsEntity in stats) {
        flashcardsList[statsEntity.amount!].add(statsEntity);
      }

      int count = 0;
      int currentAmount = 1;

      while (count < 10 && count < stats.length) {
        if (flashcardsList[currentAmount].isEmpty) {
          currentAmount = (currentAmount % highestAmount) + 1;
          continue;
        }

        StatsEntity flashcard = flashcardsList[currentAmount].removeAt(0);
        listOfStatsEntity.add(flashcard);
        count++;

        currentAmount = (currentAmount % highestAmount) + 1;
      }

      srsStreamController.add(listOfStatsEntity);
    });

    return srsStreamController.stream;
  }
  // Stream<List<StatsEntity>> srs(String uid, String setName) {
  //   final srsStreamController = StreamController<List<StatsEntity>>();
  //   List<StatsEntity> listOfStatsEntity = [];

  //   final srsCollectionRef = firestore
  //       .collection("users")
  //       .doc(uid)
  //       .collection("sets")
  //       .doc(setName)
  //       .collection("stats");

  //   final srsStream = srsCollectionRef
  //       .orderBy("amount", descending: true)
  //       // .limit(1)
  //       .snapshots()
  //       .map((querySnap) {
  //     return querySnap.docs
  //         .map((docSnap) => StatsModel.fromSnapshot(docSnap))
  //         .toList();
  //   });

  //   srsStream.listen((List<StatsEntity> stats) {
  //     StatsEntity highestStatsEntity;
  //     int highestAmount = 0;

  //     final flashcardsList = List<List<StatsEntity>>.filled(100, [],
  //         growable: false); // Assuming amount can range from 1 to 100

  //     for (StatsEntity statsEntity in stats) {
  //       flashcardsList[statsEntity.amount!].add(statsEntity);
  //       if (statsEntity.amount! > highestAmount) {
  //         highestAmount = statsEntity.amount!;
  //         highestStatsEntity = statsEntity;
  //       }
  //     }

  //     int count = 0;
  //     int currentAmount = 1;

  //     while (count < 10 && count < listOfStatsEntity.length) {
  //       if (flashcardsList[currentAmount].isEmpty) {
  //         currentAmount = currentAmount % highestAmount + 1;
  //         continue;
  //       }

  //       StatsEntity flashcard = flashcardsList[currentAmount].removeAt(0);
  //       listOfStatsEntity.add(flashcard);
  //       count++;

  //       currentAmount = currentAmount % highestAmount + 1;
  //     }

  //     srsStreamController.add(listOfStatsEntity);
  //   });

  //   return srsStreamController.stream;
  // }

  // THIS WORKS FOR UP TO 5/6 FLAHSCARDS
  // @override
  // Stream<List<StatsEntity>> srs(String uid, String setName) {
  //   final srsStreamController = StreamController<List<StatsEntity>>();
  //   List<StatsEntity> listOfStatsEntity = [];
  //   final srsCollectionRef = firestore
  //       .collection("users")
  //       .doc(uid)
  //       .collection("sets")
  //       .doc(setName)
  //       .collection("stats");

  //   final srsStream = srsCollectionRef.snapshots().map((querySnap) {
  //     return querySnap.docs
  //         .map((docSnap) => StatsModel.fromSnapshot(docSnap))
  //         .toList();
  //   });

  //   srsStream.listen((List<StatsEntity> stats) {
  //     StatsEntity highestStatsEntity;
  //     int highestAmount = 0;

  //     //Map<int, StatsEntity> flashcardsMap = {};
  //     final flashcardsMap = <int, List<StatsEntity>>{};
  //     void addValueToMap<K, V>(Map<K, List<V>> map, K key, V value) =>
  //         map.update(key, (list) => list..add(value), ifAbsent: () => [value]);

  //     for (StatsEntity statsEntity in stats) {
  //       addValueToMap(flashcardsMap, statsEntity.amount, statsEntity);
  //       if (statsEntity.amount! > highestAmount) {
  //         highestAmount = statsEntity.amount!;
  //         highestStatsEntity = statsEntity;
  //       }
  //       print(highestAmount);
  //     }

  //     int count = 0;
  //     int currentAmount = 0;

  //     while (count < 10) {
  //       if (!flashcardsMap.containsKey(currentAmount)) {
  //         currentAmount = (currentAmount % highestAmount) + 1;
  //         continue;
  //       }

  //       if (flashcardsMap[currentAmount]!.isEmpty) {
  //         currentAmount = (currentAmount % highestAmount) + 1;
  //         continue;
  //       }

  //       StatsEntity flashcard = flashcardsMap[currentAmount]!.removeAt(0);
  //       listOfStatsEntity.add(flashcard);
  //       count++;

  //       currentAmount = (currentAmount % highestAmount) + 1;
  //     }

  //     srsStreamController.add(listOfStatsEntity);
  //   });

  // return srsStreamController.stream;
  // }
  // for (int i = 0; i < flashcardsMap.length; i++) {
  //   if (flashcardsMap.containsKey(i)) {
  //     StatsEntity s = flashcardsMap[i]!;
  //     listOfStatsEntity.add(s);
  //   }
  // }
  // if (flashcardsMap.containsKey(highestAmount)) {
  //   StatsEntity s = flashcardsMap[highestAmount]!;
  //   listOfStatsEntity.add(s);
  // } else {
  //   print('Not found');
  // }
  // int count = 0;
  // int currentAmount = 1;
  // while (count < 2) {
  //   if (!flashcardsMap.containsKey(currentAmount)) {
  //     // Flashcard with the current amount is missing, find the next available flashcard
  //     for (int i = currentAmount + 1; i <= highestAmount; i++) {
  //       if (flashcardsMap.containsKey(i)) {
  //         StatsEntity flashcard = flashcardsMap[i]!;
  //         //listOfStatsEntity.add(flashcard);
  //         print(flashcard.term);
  //         // Process the flashcard with amount equal to 'i'
  //         count++;
  //         currentAmount = i;
  //         break;
  //       }
  //     }
  //   } else {
  //     // Flashcard with the current amount is present
  //     StatsEntity flashcard = flashcardsMap[currentAmount]!;
  //     listOfStatsEntity.add(flashcard);
  //     print(flashcard.term);
  //     // Process the flashcard with amount equal to 'currentAmount'
  //     count++;
  //   }
  //   currentAmount = (currentAmount % highestAmount) +
  //       1; // Circle back to the highest amount if needed
  // }

  // final srsTransformer =
  //     StreamTransformer<List<StatsEntity>, List<StatsEntity>>.fromHandlers(
  //   handleData: (stats, sink) {
  //     if (stats.isEmpty) {
  //       sink.add([]);
  //       return;
  //     }

  //     final flashcardsMap = <int, List<StatsEntity>>{};
  //     final availableFlashcards = <StatsEntity>[];

  //     for (StatsEntity statsEntity in stats) {
  //       flashcardsMap
  //           .putIfAbsent(statsEntity.amount!, () => [])
  //           .add(statsEntity);
  //       availableFlashcards.add(statsEntity);
  //     }

  //     availableFlashcards.shuffle();
  //     final selectedFlashcards = <StatsEntity>[];

  //     int currentAmount = 1;
  //     while (selectedFlashcards.length < 3) {
  //       if (flashcardsMap.containsKey(currentAmount)) {
  //         final flashcardsForAmount = flashcardsMap[currentAmount]!;
  //         if (flashcardsForAmount.isNotEmpty) {
  //           selectedFlashcards.add(flashcardsForAmount.removeAt(0));
  //         }
  //       }
  //       currentAmount = (currentAmount % flashcardsMap.length) + 1;
  //     }

  //     sink.add(selectedFlashcards);
  //   },
  // );

  @override
  Future<void> updateStats(StatsEntity statsEntity) async {
    final statsCollectionRef = firestore
        .collection("users")
        .doc(statsEntity.uid)
        .collection("sets")
        .doc(statsEntity.set)
        .collection("stats");

    final statsId = statsCollectionRef.doc().id;

    final querySnapshot = await statsCollectionRef
        .where("term", isEqualTo: statsEntity.term)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // Create new stats if it doesn't exist
      final newStats = StatsModel(
        uid: statsEntity.uid,
        set: statsEntity.set,
        term: statsEntity.term,
        amount: 1,
      ).toDocument();
      statsCollectionRef.doc(statsId).set(newStats);
    } else {
      // Update stats by increasing amount by 1
      final statsDoc = querySnapshot.docs.first;
      final currentAmount = statsDoc.data()['amount'] as int;
      final updatedAmount = currentAmount + 1;

      statsCollectionRef.doc(statsDoc.id).update({'amount': updatedAmount});
    }
  }

  @override
  Stream<List<StatsEntity>> getStats(String uid, String setName) {
    final statsCollectionRef = firestore
        .collection("users")
        .doc(uid)
        .collection("sets")
        .doc(setName)
        .collection("stats");

    return statsCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => StatsModel.fromSnapshot(docSnap))
          .toList();
    });
  }
}
