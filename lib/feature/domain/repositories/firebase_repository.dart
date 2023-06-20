import '../entities/flashcard_entity.dart';
import '../entities/set_entity.dart';
import '../entities/stats_entity.dart';
import '../entities/user_entity.dart';

abstract class FirebaseRepository {
  Future<bool> isSignIn();
  Future<String> getCurrentUId();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<void> initializeStats(String uid);
  Future<void> updateWrongAnswerStats(StatsEntity stats);
  Future<void> updateCorrectAnswerStats(StatsEntity statsEntity);
  Stream<List<SetEntity>> getSets();
  Stream<List<FlashcardEntity>> srs(String uid, String setName);
  Stream<List<StatsEntity>> getNoAnswersStats(String uid, String setName);
  Stream<List<StatsEntity>> getCorrectAnswersStats(String uid, String setName);
  Stream<List<StatsEntity>> getWrongAnswersStats(String uid, String setName);
}
