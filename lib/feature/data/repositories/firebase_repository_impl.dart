import 'package:note_app/feature/domain/entities/stats_entity.dart';
import 'package:note_app/feature/domain/entities/user_entity.dart';
import 'package:note_app/feature/domain/entities/note_entity.dart';
import 'package:note_app/feature/domain/repositories/firebase_repository.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../../domain/entities/set_entity.dart';
import '../remote/data_sources/firebase_remote_data_source.dart';

class FirebaseRepositoryImpl extends FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addNewNote(NoteEntity note) async =>
      remoteDataSource.addNewNote(note);

  @override
  Future<void> deleteNote(NoteEntity note) async =>
      remoteDataSource.deleteNote(note);

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async =>
      remoteDataSource.getCreateCurrentUser(user);

  @override
  Future<String> getCurrentUId() async => remoteDataSource.getCurrentUid();

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signIn(UserEntity user) async => remoteDataSource.signIn(user);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> signUp(UserEntity user) async => remoteDataSource.signUp(user);

  @override
  Future<void> updateNote(NoteEntity note) async =>
      remoteDataSource.updateNote(note);

  @override
  Stream<List<NoteEntity>> getNotes(String uid) =>
      remoteDataSource.getNotes(uid);

  @override
  Stream<List<SetEntity>> getSets() => remoteDataSource.getSets();

  @override
  Stream<List<FlashcardEntity>> getFlashcards(String uid) =>
      remoteDataSource.getFlashcards(uid);

  @override
  Future<void> addNewStats(StatsEntity stats) async =>
      remoteDataSource.addNewStats(stats);

  @override
  Future<void> updateStats(StatsEntity stats) async =>
      remoteDataSource.updateStats(stats);

  @override
  Stream<List<StatsEntity>> getStats(String uid, String setName) =>
      remoteDataSource.getStats(uid, setName);
}
