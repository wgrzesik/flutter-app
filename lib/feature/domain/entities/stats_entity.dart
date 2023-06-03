import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StatsEntity extends Equatable {
  final String? set;
  final String? term;
  final int? amount;
  final String? uid;
  final String? statsId;

  StatsEntity({this.set, this.term, this.amount, this.uid, this.statsId});

  @override
  // TODO: implement props
  List<Object?> get props => [set, term, amount, uid, statsId];
}
