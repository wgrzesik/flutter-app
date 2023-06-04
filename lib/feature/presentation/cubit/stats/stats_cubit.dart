import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app/feature/domain/entities/stats_entity.dart';
import 'package:note_app/feature/domain/use_cases/get_stats_usecase.dart';
import '../../../domain/use_cases/add_stats_usecase.dart';
import '../../../domain/use_cases/update_stats_usecase.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final AddStatsUseCase addStatsUseCase;
  final UpdateStatsUseCase updateStatsUseCase;
  final GetStatsUseCase getStatsUseCase;

  StatsCubit({
    required this.addStatsUseCase,
    required this.updateStatsUseCase,
    required this.getStatsUseCase,
  }) : super(StatsInitial());

  Future<void> addStats({required StatsEntity stats}) async {
    try {
      await addStatsUseCase.call(stats);
    } on SocketException catch (_) {
      emit(StatsFailure());
    } catch (_) {
      emit(StatsFailure());
    }
  }

  Future<void> updateStats({required StatsEntity stats}) async {
    try {
      await updateStatsUseCase.call(stats);
    } on SocketException catch (_) {
      emit(StatsFailure());
    } catch (_) {
      emit(StatsFailure());
    }
  }

  Future<void> getStats({required String uid, required String? setName}) async {
    emit(StatsLoading());
    try {
      getStatsUseCase.call(uid, setName!).listen((notes) {
        emit(StatsLoaded(stats: notes));
      });
    } on SocketException catch (_) {
      emit(StatsFailure());
    } catch (_) {
      emit(StatsFailure());
    }
  }
}
