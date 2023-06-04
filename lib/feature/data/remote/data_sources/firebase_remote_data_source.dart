import '../../../domain/entities/note_entity.dart';
import '../../../domain/entities/set_entity.dart';
import '../../../domain/entities/stats_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/flashcard_entity.dart';

abstract class FirebaseRemoteDataSource {
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<String> getCurrentUid();
  Future<void> getCreateCurrentUser(UserEntity user);

  Future<void> addNewNote(NoteEntity note);
  Future<void> updateNote(NoteEntity note);
  Future<void> deleteNote(NoteEntity note);
  Stream<List<NoteEntity>> getNotes(String uid);

  Stream<List<SetEntity>> getSets();
  Stream<List<FlashcardEntity>> getFlashcards(String uid);
  Future<void> initializeStats(String uid);
  Future<void> updateStats(StatsEntity stats);
  Stream<List<StatsEntity>> getStats(String uid, String setName);
}
