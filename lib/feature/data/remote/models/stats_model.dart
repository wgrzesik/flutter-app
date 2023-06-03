import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/stats_entity.dart';

class StatsModel extends StatsEntity {
  StatsModel({
    final String? set,
    final String? term,
    final int? amount,
    final String? uid,
    final String? statsId,
  }) : super(set: set, term: term, amount: amount, uid: uid, statsId: statsId);

  factory StatsModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return StatsModel(
      set: documentSnapshot.get('set'),
      term: documentSnapshot.get('term'),
      amount: documentSnapshot.get('amount'),
      uid: documentSnapshot.get('uid'),
      statsId: documentSnapshot.get('statsId'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "set": set,
      "term": term,
      "amount": amount,
      "uid": uid,
      "statsId": statsId
    };
  }
}
