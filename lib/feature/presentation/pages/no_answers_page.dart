import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app_const.dart';
import '../../domain/entities/multiple_page_arguments.dart';
import '../../domain/entities/set_entity.dart';
import '../cubit/stats/stats_cubit.dart';
import '../widgets/body_answers_stats.dart';

class NoAnswersPage extends StatefulWidget {
  final SetEntity setEntity;
  final String uid;
  const NoAnswersPage({super.key, required this.setEntity, required this.uid});

  @override
  State<NoAnswersPage> createState() => _NoAnswersPageState();
}

class _NoAnswersPageState extends State<NoAnswersPage> {
  @override
  void initState() {
    BlocProvider.of<StatsCubit>(context)
        .getNoAnswers(uid: widget.uid, setName: widget.setEntity.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              final arguments =
                  MultiplePageArguments(widget.setEntity, widget.uid);
              Navigator.pushNamed(
                context,
                PageConst.buttonStatsPage,
                arguments: arguments,
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            "Your not answered",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: BlocBuilder<StatsCubit, StatsState>(
          builder: (context, flashcardStateNo) {
            if (flashcardStateNo is StatsLoaded) {
              return bodyWidgetAnswersStats(flashcardStateNo);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
