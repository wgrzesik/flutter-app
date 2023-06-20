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

  Stream<List<SetEntity>> getSets();
  Stream<List<FlashcardEntity>> getFlashcards(String uid);
  Future<void> initializeStats(String uid);
  Future<void> updateWrongAnswerStats(StatsEntity stats);
  Stream<List<StatsEntity>> getStats(String uid, String setName);
  Stream<List<FlashcardEntity>> srs(String uid, String setName);
  Stream<List<StatsEntity>> getNoAnswersStats(String uid, String setName);
  Stream<List<StatsEntity>> getCorrectAnswersStats(String uid, String setName);
  Stream<List<StatsEntity>> getWrongAnswersStats(String uid, String setName);
  Future<void> updateCorrectAnswerStats(StatsEntity statsEntity);
}
