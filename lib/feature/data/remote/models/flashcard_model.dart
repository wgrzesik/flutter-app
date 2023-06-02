import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/flashcard_entity.dart';

class FlashcardModel extends FlashcardEntity {
  FlashcardModel({
    final int? nr,
    final String? term,
    final String? definiton,
  }) : super(
          nr: nr,
          term: term,
          definition: definiton,
        );

  factory FlashcardModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return FlashcardModel(
      nr: documentSnapshot.get('nr'),
      term: documentSnapshot.get('term'),
      definiton: documentSnapshot.get('definition'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {"nr": nr, "term": term, "definition": definition};
  }
}
