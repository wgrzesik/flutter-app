import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/feature/presentation/widgets/no_items_widget.dart';
import '../../../app_const.dart';
import '../../domain/entities/multiple_page_arguments.dart';
import '../../domain/entities/set_entity.dart';
import '../cubit/stats/stats_cubit.dart';
import '../widgets/body_answers_stats.dart';

class CorrectAnswersPage extends StatefulWidget {
  final SetEntity setEntity;
  final String uid;
  const CorrectAnswersPage(
      {super.key, required this.setEntity, required this.uid});

  @override
  State<CorrectAnswersPage> createState() => _CorrectAnswersPageState();
}

class _CorrectAnswersPageState extends State<CorrectAnswersPage> {
  @override
  void initState() {
    BlocProvider.of<StatsCubit>(context)
        .getCorrectAnswers(uid: widget.uid, setName: widget.setEntity.name);
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
          "Your correct answers",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, flashcardStateCr) {
          if (flashcardStateCr is StatsLoaded) {
            // final List<StatsEntity> listOfStatsEntity = flashcardState.stats;
            return bodyWidgetAnswersStats(flashcardStateCr);
            // if (flashcardState.stats.isEmpty) {
            //   return bodyWidgetAnswersStats(flashcardState);
            // } else {
            //   return noItemsWidget('Nothing here');
            // }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
