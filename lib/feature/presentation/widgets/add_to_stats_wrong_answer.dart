import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/stats_entity.dart';
import '../cubit/stats/stats_cubit.dart';

void addToStatsWrongAnswer(
  BuildContext context,
  String setName,
  String uid,
  String term,
  String def,
) {
  BlocProvider.of<StatsCubit>(context).updateStats(
      stats: StatsEntity(set: setName, uid: uid, term: term, def: def));
}
