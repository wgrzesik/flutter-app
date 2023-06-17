import '../entities/flashcard_entity.dart';
import '../entities/stats_entity.dart';
import '../repositories/firebase_repository.dart';

class SrsUseCase {
  final FirebaseRepository repository;

  SrsUseCase({required this.repository});

  Stream<List<FlashcardEntity>> call(String uid, String setName) {
    return repository.srs(uid, setName);
  }
}
