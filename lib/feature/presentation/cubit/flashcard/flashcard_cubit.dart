import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app/feature/domain/use_cases/srs_usecase.dart';
import '../../../domain/entities/flashcard_entity.dart';

part 'flashcard_state.dart';

class FlashcardCubit extends Cubit<FlashcardState> {
  final SrsUseCase srsUseCase;

  FlashcardCubit({
    required this.srsUseCase,
  }) : super(FlashcardInitial());

  Future<void> srs({required String uid, required String? setName}) async {
    emit(FlashcardLoading());
    try {
      bool doIt = true;
      srsUseCase.call(uid, setName!).listen((notes) {
        if (notes.length == 10 && doIt) {
          emit(FlashcardLoaded(flashcards: notes));
          doIt = false;
        }
      });
    } on SocketException catch (_) {
      emit(FlashcardFailure());
    } catch (_) {
      emit(FlashcardFailure());
    }
  }
}
