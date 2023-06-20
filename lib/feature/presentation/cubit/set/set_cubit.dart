import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/set_entity.dart';
import '../../../domain/use_cases/get_sets_usecase.dart';

part 'set_state.dart';

class SetCubit extends Cubit<SetState> {
  final GetSetsUseCase getSetsUseCase;

  SetCubit({
    required this.getSetsUseCase,
  }) : super(SetInitial());

  Future<void> getSet() async {
    emit(SetLoading());
    try {
      getSetsUseCase.call().listen((notes) {
        emit(SetLoaded(sets: notes));
      });
    } on SocketException catch (_) {
      emit(SetFailure());
    } catch (_) {
      emit(SetFailure());
    }
  }
}
