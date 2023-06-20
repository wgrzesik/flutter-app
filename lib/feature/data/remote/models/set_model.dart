import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/feature/domain/entities/set_entity.dart';

class SetModel extends SetEntity {
  const SetModel({final String? name}) : super(name: name);

  factory SetModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return SetModel(
      name: documentSnapshot.get('name'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {"name": name};
  }
}
