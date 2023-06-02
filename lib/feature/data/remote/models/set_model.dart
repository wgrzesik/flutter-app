import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/feature/domain/entities/set_entity.dart';

class SetModel extends SetEntity {
  SetModel({
    final int? nr,
    final String? term,
    final String? definiton,
  }) : super(
          nr: nr,
          term: term,
          definition: definiton,
        );

  factory SetModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return SetModel(
      nr: documentSnapshot.get('nr'),
      term: documentSnapshot.get('term'),
      definiton: documentSnapshot.get('definition'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {"nr": nr, "term": term, "definition": definition};
  }
}
