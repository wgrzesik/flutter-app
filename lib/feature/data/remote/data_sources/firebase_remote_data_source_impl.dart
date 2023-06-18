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
                    amount: 0,
                    goodAnswer: 0)
                .toDocument();
            statsCollectionRef.doc(statsId).set(newStats);
          }
        });
      }
    });
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

      statsCollectionRef
          .doc(statsDoc.id)
          .update({'amount': updatedAmount, 'goodAnswer': 0});
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
          .where((stats) => stats.amount != 0 && stats.goodAnswer == 0)
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
          .where((stats) => stats.amount == 0 && stats.goodAnswer == 0)
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
        .orderBy('amount', descending: true);

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
      final highestAmount = stats[0].amount;

      if (highestAmount == 0) {
        // Take flashcards that were not answered yet
        listOfStatsEntity.addAll(stats.where((statsEntity) =>
            statsEntity.amount == 0 && statsEntity.goodAnswer == 0));
      } else {
        // Take wrong answered flashcards
        final filteredStats = stats
            .where((statsEntity) =>
                statsEntity.amount! > 0 && statsEntity.goodAnswer == 0)
            .toList();

        for (final statsEntity in filteredStats) {
          if (!listOfStatsEntity
              .any((entity) => entity.amount == statsEntity.amount)) {
            listOfStatsEntity.add(statsEntity);
          }

          if (listOfStatsEntity.length >= 10) {
            break; // Stop once we have 10 entities
          }
        }
        // Take flashcards that were not answered yet
        if (listOfStatsEntity.length < 10) {
          listOfStatsEntity.addAll(stats.where((statsEntity) =>
              statsEntity.amount == 0 && statsEntity.goodAnswer == 0));
        }

        if (listOfStatsEntity.length < 10) {
          // Filter out entities with a goodAnswer and add them, starting from the lowest goodAnswer number
          final missingStats = stats
              .where((statsEntity) => statsEntity.goodAnswer != 0)
              .toList();
          missingStats.sort((a, b) => a.goodAnswer!.compareTo(b.goodAnswer!));

          for (final statsEntity in missingStats) {
            if (listOfStatsEntity.length >= 10) {
              break; // Stop once we have 10 entities
            }

            listOfStatsEntity.add(statsEntity);
          }
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
