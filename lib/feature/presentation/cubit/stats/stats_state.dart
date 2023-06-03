part of 'stats_cubit.dart';

abstract class StatsState extends Equatable {
  const StatsState();
}

class StatsInitial extends StatsState {
  @override
  List<Object> get props => [];
}

class StatsLoading extends StatsState {
  @override
  List<Object> get props => [];
}

class StatsFailure extends StatsState {
  @override
  List<Object> get props => [];
}

class StatsSuccess extends StatsState {
  @override
  List<Object> get props => [];
}
