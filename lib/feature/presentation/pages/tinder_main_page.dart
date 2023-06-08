import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:swipeable_card_stack/swipeable_card_stack.dart';

import '../../../app_const.dart';
import '../../domain/entities/set_entity.dart';
import '../../domain/entities/stats_entity.dart';
import '../cubit/stats/stats_cubit.dart';

class TinderMain extends StatefulWidget {
  final SetEntity setEntity;
  final String uid;

  const TinderMain({super.key, required this.uid, required this.setEntity});

  @override
  State<TinderMain> createState() => _TinderMainState();
}

class _TinderMainState extends State<TinderMain> {
  SwipeableCardSectionController? cardController;
  @override
  void initState() {
    BlocProvider.of<StatsCubit>(context)
        .srs(uid: widget.uid, setName: widget.setEntity.name);
    super.initState();
    cardController = SwipeableCardSectionController();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              PageConst.flahscardHomePage,
              arguments: widget.uid,
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "${widget.setEntity.name} flashcards",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, flashcardState) {
          if (flashcardState is StatsLoaded) {
            return _bodyWidget(context, flashcardState, cardController!);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Widget _bodyWidget(BuildContext context, StatsState statsState,
    SwipeableCardSectionController cardController) {
  if (statsState is StatsLoaded) {
    final List<StatsEntity> listOfStatsEntity = statsState.stats;
    final List<Widget> flashcards = [];

    for (int index = 0; index < 10; index++) {
      final StatsEntity stat = listOfStatsEntity[index];
      final Widget flashcard = buildFlashcard(stat.term!, stat.def!, index);
      flashcards.add(flashcard);
    }
    List<Widget> restOfItems = flashcards.sublist(3);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SwipeableCardsSection(
          cardController: cardController,
          context: context,
          items: flashcards,
          onCardSwiped: (dir, index, widget) {
            if (index < restOfItems.toList().length) {
              cardController.addItem(restOfItems[index]);
            }
          },
          enableSwipeUp: false,
          enableSwipeDown: false,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: 'wrong',
                child: const Icon(Icons.chevron_left),
                onPressed: () {
                  //addToStatsWrongAnswer(context, setName, uid, term, def);
                  cardController.triggerSwipeLeft();
                },
              ),
              FloatingActionButton(
                heroTag: 'right',
                child: const Icon(Icons.chevron_right),
                onPressed: () => cardController.triggerSwipeRight(),
              ),
            ],
          ),
        )
      ],
    );
  }
  return Center(child: CircularProgressIndicator());
}

Widget buildFlashcard(String term, String def, int index) {
  final heroTag = 'flashcardHero_$index';

  return Card(
    color: Colors.deepPurple,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Hero(
      tag: heroTag,
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        front: SizedBox(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                term,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        back: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              def,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
