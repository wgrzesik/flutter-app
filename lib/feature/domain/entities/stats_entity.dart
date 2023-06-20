import 'package:equatable/equatable.dart';

class StatsEntity extends Equatable {
  final String? set;
  final String? term;
  final int? badAnswer;
  final String? uid;
  final String? def;
  final int? goodAnswer;

  const StatsEntity(
      {this.set,
      this.term,
      this.badAnswer,
      this.uid,
      this.def,
      this.goodAnswer});

  @override
  List<Object?> get props => [set, term, badAnswer, uid, def, goodAnswer];
}
