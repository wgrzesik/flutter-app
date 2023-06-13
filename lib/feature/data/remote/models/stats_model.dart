import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/stats_entity.dart';

class StatsModel extends StatsEntity {
  StatsModel(
      {final String? set,
      final String? term,
      final int? amount,
      final String? uid,
      final String? def,
      final int? goodAnswer})
      : super(
            set: set,
            term: term,
            amount: amount,
            uid: uid,
            def: def,
            goodAnswer: goodAnswer);

  factory StatsModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return StatsModel(
        set: documentSnapshot.get('set'),
        term: documentSnapshot.get('term'),
        amount: documentSnapshot.get('amount'),
        uid: documentSnapshot.get('uid'),
        def: documentSnapshot.get('def'),
        goodAnswer: documentSnapshot.get('goodAnswer'));
  }

  Map<String, dynamic> toDocument() {
    return {
      "set": set,
      "term": term,
      "amount": amount,
      "uid": uid,
      "def": def,
      "goodAnswer": goodAnswer
    };
  }
}
