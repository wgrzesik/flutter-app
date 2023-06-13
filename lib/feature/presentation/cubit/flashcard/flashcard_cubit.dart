import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/flashcard_entity.dart';
import '../../../domain/use_cases/get_flashcard_usecase.dart';

part 'flashcard_state.dart';

class FlashcardCubit extends Cubit<FlashcardState> {
  final GetFlashcardsUseCase getFlashcardsUseCase;

  FlashcardCubit({
    required this.getFlashcardsUseCase,
  }) : super(FlashcardInitial());

  Future<void> getFlashcard({required String? uid}) async {
    emit(FlashcardLoading());
    try {
      getFlashcardsUseCase.call(uid!).listen((notes) {
        emit(FlashcardLoaded(flashcards: notes));
      });
    } on SocketException catch (_) {
      emit(FlashcardFailure());
    } catch (_) {
      emit(FlashcardFailure());
    }
  }
}
