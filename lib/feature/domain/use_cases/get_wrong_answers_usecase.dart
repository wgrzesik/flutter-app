import '../entities/stats_entity.dart';
import '../repositories/firebase_repository.dart';

class GetWrongAnswersUseCase {
  final FirebaseRepository repository;

  GetWrongAnswersUseCase({required this.repository});

  Stream<List<StatsEntity>> call(String uid, String setName) {
    return repository.getWrongAnswersStats(uid, setName);
  }
}
