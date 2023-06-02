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
  final GetSetsUseCase getNotesUseCase;

  SetCubit({
    required this.getNotesUseCase,
  }) : super(SetInitial());

  Future<void> getSet({required String uid}) async {
    emit(SetLoading());
    try {
      getNotesUseCase.call(uid).listen((notes) {
        emit(SetLoaded(sets: notes));
      });
    } on SocketException catch (_) {
      emit(SetFailure());
    } catch (_) {
      emit(SetFailure());
    }
  }
}
