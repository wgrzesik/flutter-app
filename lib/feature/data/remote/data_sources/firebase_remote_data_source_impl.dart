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
  Future<void> addNewStats(StatsEntity statsEntity) async {
    final statsCollectionRef = firestore
        .collection("users")
        .doc(statsEntity.uid)
        .collection("sets")
        .doc("nature")
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
  Future<void> updateStats(StatsEntity stats) async {
    Map<String, dynamic> statsMap = Map();
    final noteCollectionRef = firestore
        .collection("users")
        .doc(stats.uid)
        .collection("sets")
        .doc("nature")
        .collection("stats");

    if (stats.amount != null) statsMap['note'] = stats.amount;

    noteCollectionRef.doc(stats.statsId).update(statsMap);
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
