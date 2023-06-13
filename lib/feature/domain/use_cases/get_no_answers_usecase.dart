import '../entities/stats_entity.dart';
import '../repositories/firebase_repository.dart';

class GetNoAnswersUseCase {
  final FirebaseRepository repository;

  GetNoAnswersUseCase({required this.repository});

  Stream<List<StatsEntity>> call(String uid, String setName) {
    return repository.getNoAnswersStats(uid, setName);
  }
}
