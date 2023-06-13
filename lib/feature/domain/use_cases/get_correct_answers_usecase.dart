import '../entities/stats_entity.dart';
import '../repositories/firebase_repository.dart';

class GetCorrectAnswersUseCase {
  final FirebaseRepository repository;

  GetCorrectAnswersUseCase({required this.repository});

  Stream<List<StatsEntity>> call(String uid, String setName) {
    return repository.getCorrectAnswersStats(uid, setName);
  }
}
