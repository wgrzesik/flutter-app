import '../repositories/firebase_repository.dart';

class AddStatsUseCase {
  final FirebaseRepository repository;

  AddStatsUseCase({required this.repository});

  Future<void> call(String uid) async {
    return repository.initializeStats(uid);
  }
}
