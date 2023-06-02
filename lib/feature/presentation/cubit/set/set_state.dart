part of 'set_cubit.dart';

abstract class SetState extends Equatable {
  const SetState();
}

class SetInitial extends SetState {
  @override
  List<Object> get props => [];
}

class SetLoading extends SetState {
  @override
  List<Object> get props => [];
}

class SetFailure extends SetState {
  @override
  List<Object> get props => [];
}

class SetLoaded extends SetState {
  final List<SetEntity> sets;

  const SetLoaded({required this.sets});
  @override
  List<Object> get props => [sets];
}
