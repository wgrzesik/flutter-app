import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app/feature/domain/entities/note_entity.dart';
import 'package:note_app/feature/domain/use_cases/add_new_note_usecase.dart';
import 'package:note_app/feature/domain/use_cases/delete_note_usecase.dart';
import 'package:note_app/feature/domain/use_cases/get_notes_usecase.dart';
import 'package:note_app/feature/domain/use_cases/update_note_usecase.dart';

import '../../../domain/entities/flashcard_entity.dart';
import '../../../domain/entities/set_entity.dart';
import '../../../domain/use_cases/get_flashcard_usecase.dart';
import '../../../domain/use_cases/get_sets_usecase.dart';

part 'flashcard_state.dart';

class FlashcardCubit extends Cubit<FlashcardState> {
  final GetFlashcardsUseCase getFlashcardsUseCase;

  FlashcardCubit({
    required this.getFlashcardsUseCase,
  }) : super(FlashcardInitial());

  Future<void> getSet({required String uid}) async {
    emit(FlashcardLoading());
    try {
      getFlashcardsUseCase.call(uid).listen((notes) {
        emit(FlashcardLoaded(flashcards: notes));
      });
    } on SocketException catch (_) {
      emit(FlashcardFailure());
    } catch (_) {
      emit(FlashcardFailure());
    }
  }
}
