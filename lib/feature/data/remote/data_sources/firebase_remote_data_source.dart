import '../../../domain/entities/set_entity.dart';
import '../../../domain/entities/stats_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/flashcard_entity.dart';

abstract class FirebaseRemoteDataSource {
  Future<bool> isSignIn();
  Future<String> getCurrentUid();
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
