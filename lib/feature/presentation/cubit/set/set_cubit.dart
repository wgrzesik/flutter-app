import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app/feature/domain/entities/note_entity.dart';
import 'package:note_app/feature/domain/use_cases/add_new_note_usecase.dart';
import 'package:note_app/feature/domain/use_cases/delete_note_usecase.dart';
import 'package:note_app/feature/domain/use_cases/get_notes_usecase.dart';
import 'package:note_app/feature/domain/use_cases/update_note_usecase.dart';

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
