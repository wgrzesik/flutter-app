import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app/feature/domain/use_cases/srs_usecase.dart';
import '../../../domain/entities/flashcard_entity.dart';
import '../../../domain/use_cases/get_flashcard_usecase.dart';

part 'flashcard_state.dart';

class FlashcardCubit extends Cubit<FlashcardState> {
  final GetFlashcardsUseCase getFlashcardsUseCase;
  final SrsUseCase srsUseCase;

  FlashcardCubit({
    required this.getFlashcardsUseCase,
    required this.srsUseCase,
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

  Future<void> srs({required String uid, required String? setName}) async {
    emit(FlashcardLoading());
    try {
      srsUseCase.call(uid, setName!).listen((notes) {
        if (notes.length == 10) {
          emit(FlashcardLoaded(flashcards: notes));
        }
      });
      // final stream = srsUseCase.call(uid, setName!);
      // stream.last.then((notes) {
      //   //await for (final notes in stream) {
      //   print('Length of notes in flashcardCubit ${notes.length}');
      //   emit(FlashcardLoaded(flashcards: notes));
      // });
    } on SocketException catch (_) {
      emit(FlashcardFailure());
    } catch (_) {
      emit(FlashcardFailure());
    }
  }
}
