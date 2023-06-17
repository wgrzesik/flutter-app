import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app_const.dart';
import '../../domain/entities/multiple_page_arguments.dart';
import '../../domain/entities/set_entity.dart';
import '../cubit/stats/stats_cubit.dart';
import '../widgets/body_answers_stats.dart';
import '../widgets/no_items_widget.dart';

class WrongAnswersPage extends StatefulWidget {
  final SetEntity setEntity;
  final String uid;
  const WrongAnswersPage(
      {super.key, required this.uid, required this.setEntity});

  @override
  State<WrongAnswersPage> createState() => _WrongAnswersPageState();
}

class _WrongAnswersPageState extends State<WrongAnswersPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StatsCubit>(context)
        .getWrongAnswers(uid: widget.uid, setName: widget.setEntity.name);
    // cubitWr = BlocProvider.of<StatsCubit>(context);
    // cubitWr.getWrongAnswers(uid: widget.uid, setName: widget.setEntity.name);
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
          "Your wrong answers",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, flashcardStateWr) {
          if (flashcardStateWr is StatsLoaded) {
            // if (flashcardState.stats.isEmpty) {
            //   return bodyWidgetAnswersStats(flashcardState);
            // } else {
            //   return noItemsWidget('Nothing here');
            // }
            return bodyWidgetAnswersStats(flashcardStateWr);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
