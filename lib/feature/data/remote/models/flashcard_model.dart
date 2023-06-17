import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/flashcard_entity.dart';

class FlashcardModel extends FlashcardEntity {
  FlashcardModel({
    final String? term,
    final String? def,
  }) : super(term: term, def: def);

  factory FlashcardModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return FlashcardModel(
      term: documentSnapshot.get('term'),
      def: documentSnapshot.get('def'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {"term": term, "def": def};
  }
}
