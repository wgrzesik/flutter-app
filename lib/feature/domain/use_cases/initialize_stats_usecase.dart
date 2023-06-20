import '../repositories/firebase_repository.dart';

class InitializeStatsUseCase {
  final FirebaseRepository repository;

  InitializeStatsUseCase({required this.repository});

  Future<void> call(String uid) async {
    return repository.initializeStats(uid);
  }
}
