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
              def: flashcardEntity.def,
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
        def: statsEntity.def,
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
