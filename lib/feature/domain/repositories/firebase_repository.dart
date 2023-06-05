import '../entities/flashcard_entity.dart';
import '../entities/note_entity.dart';
import '../entities/set_entity.dart';
import '../entities/stats_entity.dart';
import '../entities/user_entity.dart';

abstract class FirebaseRepository {
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<String> getCurrentUId();
  Future<void> getCreateCurrentUser(UserEntity user);

  Future<void> addNewNote(NoteEntity note);
  Future<void> updateNote(NoteEntity note);
  Future<void> deleteNote(NoteEntity note);
  Stream<List<NoteEntity>> getNotes(String uid);

  Stream<List<SetEntity>> getSets();
  Stream<List<FlashcardEntity>> getFlashcards(String uid);
  Future<void> initializeStats(String stats);
  Future<void> updateStats(StatsEntity stats);
  Stream<List<StatsEntity>> getStats(String uid, String setName);
  Stream<List<StatsEntity>> srs(String uid, String setName);
}
