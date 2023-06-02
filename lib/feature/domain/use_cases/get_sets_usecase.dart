import '../entities/set_entity.dart';
import '../repositories/firebase_repository.dart';

class GetSetsUseCase {
  final FirebaseRepository repository;

  GetSetsUseCase({required this.repository});

  Stream<List<SetEntity>> call() {
    return repository.getSets();
  }
}
