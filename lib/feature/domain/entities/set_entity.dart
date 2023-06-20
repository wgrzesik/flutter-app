import 'package:equatable/equatable.dart';

class SetEntity extends Equatable {
  final String? name;

  const SetEntity({this.name});

  @override
  List<Object?> get props => [name];
}
