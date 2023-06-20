import 'package:equatable/equatable.dart';

class FlashcardEntity extends Equatable {
  final int? nr;
  final String? term;
  final String? def;

  const FlashcardEntity({this.nr, this.term, this.def});

  @override
  List<Object?> get props => [nr, term, def];
}
