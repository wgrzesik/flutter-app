import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FlashcardEntity extends Equatable {
  final int? nr;
  final String? term;
  final String? definition;

  FlashcardEntity({this.nr, this.term, this.definition});

  @override
  // TODO: implement props
  List<Object?> get props => [nr, term, definition];
}
