import 'package:equatable/equatable.dart';

class SetEntity extends Equatable {
  final String? name;

  SetEntity({this.name});

  @override
  List<Object?> get props => [name];
}
