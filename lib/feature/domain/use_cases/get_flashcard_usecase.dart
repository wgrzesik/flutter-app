import 'package:note_app/feature/domain/entities/flashcard_entity.dart';
import '../repositories/firebase_repository.dart';

class GetFlashcardsUseCase {
  final FirebaseRepository repository;

  GetFlashcardsUseCase({required this.repository});

  Stream<List<FlashcardEntity>> call(String uid) {
    return repository.getFlashcards(uid);
  }
}
