import 'package:note_app/feature/domain/entities/stats_entity.dart';
import '../repositories/firebase_repository.dart';

class UpdateStatsUseCase {
  final FirebaseRepository repository;

  UpdateStatsUseCase({required this.repository});

  Future<void> call(StatsEntity stats) async {
    return repository.updateStats(stats);
  }
}
