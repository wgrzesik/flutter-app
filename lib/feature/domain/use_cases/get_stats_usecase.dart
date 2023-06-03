import '../entities/stats_entity.dart';
import '../repositories/firebase_repository.dart';

class GetStatsUseCase {
  final FirebaseRepository repository;

  GetStatsUseCase({required this.repository});

  Stream<List<StatsEntity>> call(String uid, String setName) {
    return repository.getStats(uid, setName);
  }
}
