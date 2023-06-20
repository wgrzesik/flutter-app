import 'package:note_app/feature/domain/entities/stats_entity.dart';
import 'package:note_app/feature/domain/entities/user_entity.dart';
import 'package:note_app/feature/domain/repositories/firebase_repository.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../../domain/entities/set_entity.dart';
import '../remote/data_sources/firebase_remote_data_source.dart';

class FirebaseRepositoryImpl extends FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});

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
  Stream<List<SetEntity>> getSets() => remoteDataSource.getSets();

  @override
  Stream<List<FlashcardEntity>> getFlashcards(String uid) =>
      remoteDataSource.getFlashcards(uid);

  @override
  Future<void> initializeStats(String uid) async =>
      remoteDataSource.initializeStats(uid);

  @override
  Future<void> updateWrongAnswerStats(StatsEntity stats) async =>
      remoteDataSource.updateWrongAnswerStats(stats);

  @override
  Stream<List<StatsEntity>> getStats(String uid, String setName) =>
      remoteDataSource.getStats(uid, setName);

  @override
  Stream<List<FlashcardEntity>> srs(String uid, String setName) =>
      remoteDataSource.srs(uid, setName);

  @override
  Stream<List<StatsEntity>> getCorrectAnswersStats(
          String uid, String setName) =>
      remoteDataSource.getCorrectAnswersStats(uid, setName);

  @override
  Stream<List<StatsEntity>> getNoAnswersStats(String uid, String setName) =>
      remoteDataSource.getNoAnswersStats(uid, setName);

  @override
  Stream<List<StatsEntity>> getWrongAnswersStats(String uid, String setName) =>
      remoteDataSource.getWrongAnswersStats(uid, setName);

  @override
  Future<void> updateCorrectAnswerStats(StatsEntity statsEntity) async =>
      remoteDataSource.updateCorrectAnswerStats(statsEntity);
}
