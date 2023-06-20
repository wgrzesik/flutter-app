import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app/feature/domain/entities/stats_entity.dart';
import 'package:note_app/feature/domain/use_cases/get_correct_answers_usecase.dart';
import 'package:note_app/feature/domain/use_cases/get_no_answers_usecase.dart';
import 'package:note_app/feature/domain/use_cases/get_wrong_answers_usecase.dart';
import 'package:note_app/feature/domain/use_cases/update_correct_answer_stats_usecase.dart';
import '../../../domain/use_cases/initialize_stats_usecase.dart';
import '../../../domain/use_cases/update_wrong_answer_stats_usecase.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final InitializeStatsUseCase addStatsUseCase;
  final UpdateStatsUseCase updateStatsUseCase;
  final GetWrongAnswersUseCase getWrongAnswersUseCase;
  final GetCorrectAnswersUseCase getCorrectAnswersUseCase;
  final GetNoAnswersUseCase getNoAnswersUseCase;
  final UpdateCorrectAnswerUseCase updateCorrectAnswerUseCase;

  StatsCubit({
    required this.addStatsUseCase,
    required this.updateStatsUseCase,
    required this.getCorrectAnswersUseCase,
    required this.getWrongAnswersUseCase,
    required this.getNoAnswersUseCase,
    required this.updateCorrectAnswerUseCase,
  }) : super(StatsInitial());

  Future<void> addStats({required String stats}) async {
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

  Future<void> getWrongAnswers(
      {required String uid, required String? setName}) async {
    emit(StatsLoading());
    try {
      getWrongAnswersUseCase.call(uid, setName!).listen((notes) {
        emit(StatsLoaded(stats: notes));
      });
    } on SocketException catch (_) {
      emit(StatsFailure());
    } catch (_) {
      emit(StatsFailure());
    }
  }

  Future<void> getCorrectAnswers(
      {required String uid, required String? setName}) async {
    emit(StatsLoading());
    try {
      getCorrectAnswersUseCase.call(uid, setName!).listen((notes) {
        emit(StatsLoaded(stats: notes));
      });
    } on SocketException catch (_) {
      emit(StatsFailure());
    } catch (_) {
      emit(StatsFailure());
    }
  }

  Future<void> getNoAnswers(
      {required String uid, required String? setName}) async {
    emit(StatsLoading());
    try {
      getNoAnswersUseCase.call(uid, setName!).listen((notes) {
        emit(StatsLoaded(stats: notes));
      });
    } on SocketException catch (_) {
      emit(StatsFailure());
    } catch (_) {
      emit(StatsFailure());
    }
  }

  Future<void> updateCorrectAnswer({required StatsEntity stats}) async {
    try {
      await updateCorrectAnswerUseCase.call(stats);
    } on SocketException catch (_) {
      emit(StatsFailure());
    } catch (_) {
      emit(StatsFailure());
    }
  }
}
