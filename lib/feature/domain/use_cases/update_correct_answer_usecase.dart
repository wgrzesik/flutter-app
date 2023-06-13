import 'package:note_app/feature/domain/entities/stats_entity.dart';
import '../repositories/firebase_repository.dart';

class UpdateCorrectAnswerUseCase {
  final FirebaseRepository repository;

  UpdateCorrectAnswerUseCase({required this.repository});

  Future<void> call(StatsEntity stats) async {
    return repository.updateCorrectAnswerStats(stats);
  }
}
