import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/feature/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    final String? name,
    final String? email,
    final String? uid,
    final String? password,
  }) : super(
          uid: uid,
          name: name,
          email: email,
          password: password,
        );

  factory UserModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return UserModel(
      name: documentSnapshot.get('name'),
      uid: documentSnapshot.get('uid'),
      email: documentSnapshot.get('email'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {"uid": uid, "email": email, "name": name};
  }
}
