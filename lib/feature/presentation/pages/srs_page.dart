import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import '../../../app_const.dart';
import '../../domain/entities/multiple_page_arguments.dart';
import '../../domain/entities/set_entity.dart';
import '../../domain/entities/stats_entity.dart';
import '../cubit/stats/stats_cubit.dart';

class SrsPage extends StatefulWidget {
  final SetEntity setEntity;
  final String uid;

  const SrsPage({super.key, required this.uid, required this.setEntity});

  @override
  State<SrsPage> createState() => _SrsPageState();
}

class _SrsPageState extends State<SrsPage> {
  SwipeableCardSectionController? cardController;
  String? setName;
  String? uid;
  int current = 0;
  int goodAnswears = 0;
  int badAnswears = 0;

  @override
  void initState() {
    BlocProvider.of<StatsCubit>(context)
        .srs(uid: widget.uid, setName: widget.setEntity.name);
    super.initState();
    cardController = SwipeableCardSectionController();
    setName = widget.setEntity.name!;
    uid = widget.uid;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            final List<StatsEntity> listOfStatsEntity = flashcardState.stats;
            //print(listOfStatsEntity.length);
            return _bodyWidget(
                context, listOfStatsEntity, cardController!, setName!, uid!);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _bodyWidget(
    BuildContext context,
    List<StatsEntity> listOfStatsEntity,
    SwipeableCardSectionController cardController,
    String setName,
    String uid,
  ) {
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
            setState(() {
              current = index;
            });
            if (index < restOfItems.toList().length) {
              cardController.addItem(restOfItems[index]);
            }

            if (index == 9) {
              // go to the page that shows how many good and bad anwears and that you did good job!
              final arguments = MultiplePageArgumentsSetName(
                  setName, uid, badAnswears, goodAnswears);
              Navigator.pushNamed(
                context,
                PageConst.endOfFlashcardsPage,
                arguments: arguments,
              );
            }
            if (dir == Direction.left) {
              addToStatsWrongAnswer(
                  context,
                  setName,
                  uid,
                  listOfStatsEntity[current].term!,
                  listOfStatsEntity[current].def!);
              setState(() {
                badAnswears += 1;
              });
            } else if (dir == Direction.right) {
              addToStatsCorrectAnswer(
                  context,
                  setName,
                  uid,
                  listOfStatsEntity[current].term!,
                  listOfStatsEntity[current].def!);
              setState(() {
                goodAnswears += 1;
              });
            } else if (dir == Direction.up) {
              return false;
            } else if (dir == Direction.down) {
              return false;
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
                backgroundColor: Colors.white,
                heroTag: 'wrong',
                child: const FaIcon(
                  FontAwesomeIcons.xmark,
                  color: Color.fromARGB(255, 155, 14, 4),
                ),
                onPressed: () {
                  cardController.triggerSwipeLeft();
                },
              ),
              FloatingActionButton(
                backgroundColor: Colors.white,
                heroTag: 'right',
                child: const FaIcon(FontAwesomeIcons.check,
                    color: Color.fromARGB(255, 22, 94, 25)),
                onPressed: () => cardController.triggerSwipeRight(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildFlashcard(String term, String def, int index) {
    final heroTag = 'flashcardHero_$index';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Hero(
        tag: heroTag,
        child: FlipCard(
          direction: FlipDirection.HORIZONTAL,
          front: SizedBox(
            child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF006666),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: contentOfFlipCard(term, index)),
          ),
          back: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 52, 153, 153),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: contentOfFlipCard(def, index)),
        ),
      ),
    );
  }

  contentOfFlipCard(text, index) {
    return Column(children: [
      Expanded(
        flex: 1,
        child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text('${index + 1}/10',
                  style: const TextStyle(color: Colors.white)),
            )),
      ),
      Expanded(
        flex: 5,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      const Expanded(
        flex: 1,
        child: Align(
            alignment: Alignment.center,
            child:
                Text('Click to flip', style: TextStyle(color: Colors.white))),
      ),
    ]);
  }

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
}
