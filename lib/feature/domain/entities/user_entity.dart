import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? name;
  final String? email;
  final String? uid;
  final String? password;

  UserEntity({this.name, this.email, this.uid, this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [
        name,
        email,
        uid,
        password,
      ];
}
