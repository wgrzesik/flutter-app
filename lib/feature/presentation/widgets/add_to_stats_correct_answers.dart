import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/stats_entity.dart';
import '../cubit/stats/stats_cubit.dart';

void addToStatsCorrectAnswer(
  BuildContext context,
  String setName,
  String uid,
  String term,
  String def,
) {
  BlocProvider.of<StatsCubit>(context).updateCorrectAnswer(
      stats: StatsEntity(set: setName, uid: uid, term: term, def: def));
}
