import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/feature/data/remote/models/user_model.dart';
import 'package:note_app/feature/domain/entities/stats_entity.dart';
import 'package:note_app/feature/domain/entities/user_entity.dart';
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
                    badAnswer: 0,
                    goodAnswer: 0)
                .toDocument();
            statsCollectionRef.doc(statsId).set(newStats);
          }
        });
      }
    });
  }

  @override
  Future<void> updateWrongAnswerStats(StatsEntity statsEntity) async {
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
        badAnswer: 1,
      ).toDocument();
      statsCollectionRef.doc(statsId).set(newStats);
    } else {
      // Update stats by increasing nadAnswer by 1
      final statsDoc = querySnapshot.docs.first;
      final currentAmount = statsDoc.data()['badAnswer'] as int;
      final updatedAmount = currentAmount + 1;

      statsCollectionRef
          .doc(statsDoc.id)
          .update({'badAnswer': updatedAmount, 'goodAnswer': 0});
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

  @override
  Stream<List<StatsEntity>> getWrongAnswersStats(String uid, String setName) {
    final statsCollectionRef = firestore
        .collection("users")
        .doc(uid)
        .collection("sets")
        .doc(setName)
        .collection("stats");

    return statsCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => StatsModel.fromSnapshot(docSnap))
          .where((stats) => stats.badAnswer != 0 && stats.goodAnswer == 0)
          .toList();
    });
  }

  @override
  Stream<List<StatsEntity>> getCorrectAnswersStats(String uid, String setName) {
    final statsCollectionRef = firestore
        .collection("users")
        .doc(uid)
        .collection("sets")
        .doc(setName)
        .collection("stats");

    return statsCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => StatsModel.fromSnapshot(docSnap))
          .where((stats) => stats.goodAnswer != 0)
          .toList();
    });
  }

  @override
  Stream<List<StatsEntity>> getNoAnswersStats(String uid, String setName) {
    final statsCollectionRef = firestore
        .collection("users")
        .doc(uid)
        .collection("sets")
        .doc(setName)
        .collection("stats");

    return statsCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => StatsModel.fromSnapshot(docSnap))
          .where((stats) => stats.badAnswer == 0 && stats.goodAnswer == 0)
          .toList();
    });
  }

  @override
  Future<void> updateCorrectAnswerStats(StatsEntity statsEntity) async {
    final statsCollectionRef = firestore
        .collection("users")
        .doc(statsEntity.uid)
        .collection("sets")
        .doc(statsEntity.set)
        .collection("stats");

    final querySnapshot = await statsCollectionRef
        .where("term", isEqualTo: statsEntity.term)
        .get();

    final statsDoc = querySnapshot.docs.first;
    final currentGoodAnswer = statsDoc.data()['goodAnswer'] as int;
    final updatedGoodAnswer = currentGoodAnswer + 1;

    statsCollectionRef
        .doc(statsDoc.id)
        .update({'goodAnswer': updatedGoodAnswer});
  }

  @override
  Stream<List<FlashcardEntity>> srs(String uid, String setName) {
    final listOfStatsEntity = <StatsEntity>[];
    final statsCollectionRef =
        firestore.collection("users").doc(uid).collection("srs_$setName");

    final srsCollectionRef = firestore
        .collection("users")
        .doc(uid)
        .collection("sets")
        .doc(setName)
        .collection("stats")
        .orderBy('badAnswer', descending: true);

    final srsStream = srsCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => StatsModel.fromSnapshot(docSnap))
          .toList();
    });

    statsCollectionRef.get().then((snapshot) {
      for (final doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    //srsStream.listen((List<StatsEntity> stats) {
    srsStream.first.then((stats) {
      final highestAmount = stats[0].badAnswer;

      if (highestAmount == 0) {
        final notAnsweredFlashcards = stats
            .where((statsEntity) =>
                statsEntity.badAnswer == 0 && statsEntity.goodAnswer == 0)
            .take(10) // Take only 10 flashcards
            .toList();

        listOfStatsEntity.addAll(notAnsweredFlashcards);
      } else {
        // Take wrong answered flashcards
        final filteredStats = stats
            .where((statsEntity) =>
                statsEntity.badAnswer! > 0 && statsEntity.goodAnswer == 0)
            .toList();

        for (final statsEntity in filteredStats) {
          if (!listOfStatsEntity
              .any((entity) => entity.badAnswer == statsEntity.badAnswer)) {
            listOfStatsEntity.add(statsEntity);
          }

          if (listOfStatsEntity.length >= 10) {
            break; // Stop once we have 10 entities
          }
        }
        // Take flashcards that were not answered yet
        if (listOfStatsEntity.length < 10) {
          final notAnsweredStats = stats
              .where((statsEntity) =>
                  statsEntity.badAnswer == 0 && statsEntity.goodAnswer == 0)
              .take(10 -
                  listOfStatsEntity
                      .length) // Take only the remaining needed flashcards
              .toList();

          listOfStatsEntity.addAll(notAnsweredStats);
        }

        if (listOfStatsEntity.length < 10) {
          // Filter out entities with a goodAnswer and add them, starting from the lowest goodAnswer number
          final missingStats = stats
              .where((statsEntity) => statsEntity.goodAnswer != 0)
              .toList();
          missingStats.sort((a, b) => a.goodAnswer!.compareTo(b.goodAnswer!));

          missingStats.takeWhile((statsEntity) {
            if (listOfStatsEntity.length < 10) {
              listOfStatsEntity.add(statsEntity);
            }
            return listOfStatsEntity.length < 10;
          });

          // for (final statsEntity in missingStats) {
          //   if (listOfStatsEntity.length >= 10) {
          //     break; // Stop once we have 10 entities
          //   }

          //   listOfStatsEntity.add(statsEntity);
          // }
        }
      }

      // Remove extra items if the list is longer than 10
      if (listOfStatsEntity.length > 10) {
        listOfStatsEntity.removeRange(10, listOfStatsEntity.length);
      }
      print('Length of listOfStatsEntity in srs ${listOfStatsEntity.length}');

      for (StatsEntity stat in listOfStatsEntity) {
        print(stat.term);
        final statsId = statsCollectionRef.doc().id;
        final newStats = FlashcardModel(
          term: stat.term,
          def: stat.def,
        ).toDocument();
        statsCollectionRef.doc(statsId).set(newStats);
      }
    });

    return statsCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => FlashcardModel.fromSnapshot(docSnap))
          .toList();
    });
  }
}
