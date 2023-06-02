import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SetEntity extends Equatable {
  final String? name;

  SetEntity({this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [name];
}
