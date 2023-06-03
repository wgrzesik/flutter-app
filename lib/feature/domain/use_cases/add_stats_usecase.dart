import 'package:note_app/feature/domain/entities/stats_entity.dart';

import '../repositories/firebase_repository.dart';

class AddStatsUseCase {
  final FirebaseRepository repository;

  AddStatsUseCase({required this.repository});

  Future<void> call(StatsEntity stats) async {
    return repository.addNewStats(stats);
  }
}
