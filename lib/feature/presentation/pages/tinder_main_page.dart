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
  late String setName;
  late String uid;
  late Future<List<StatsEntity>> statsFuture;
  late List<Widget> firstThreeItems;

  @override
  void initState() {
    super.initState();
    statsFuture = fetchStats();
    setName = widget.setEntity.name!;
    uid = widget.uid;
  }

  Future<List<StatsEntity>> fetchStats() async {
    final listOfStats = await BlocProvider.of<StatsCubit>(context)
        .srs(uid: widget.uid, setName: setName)
        .first;
    return listOfStats;
  }

  @override
  Widget build(BuildContext context) {
    final cardController = SwipeableCardSectionController();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String term = '';
    String def = '';
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
      body: StreamBuilder<List<StatsEntity>>(
        // stream: BlocProvider.of<StatsCubit>(context)
        //     .srs(uid: widget.uid, setName: widget.setEntity.name),
        stream: Stream.fromFuture(statsFuture),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final listOfStatsEntity = snapshot.data!;
            firstThreeItems = listOfStatsEntity
                .asMap()
                .map((index, stat) {
                  return MapEntry(
                      index,
                      buildCard(screenWidth, screenHeight, stat.term, stat.def,
                          index));
                })
                .values
                .toList();
            List<Widget> restOfItems = firstThreeItems.sublist(3);
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SwipeableCardsSection(
                  cardController: cardController,
                  context: context,
                  items: firstThreeItems,
                  onCardSwiped: (dir, index, widget) {
                    setState(() {
                      term = listOfStatsEntity[index].term!;
                      def = listOfStatsEntity[index].def!;
                    });
                    if (index < restOfItems.toList().length) {
                      cardController.addItem(restOfItems[index]);
                    }
                    if (dir == Direction.left) {
                      addToStatsWrongAnswer(context, setName, uid, term, def);
                    } else if (dir == Direction.right) {
                      // print('onLiked ${(widget as CardView).text} $index');
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
                          child: const Icon(Icons.chevron_left),
                          onPressed: () {
                            cardController.triggerSwipeLeft();
                            addToStatsWrongAnswer(
                                context, setName, uid, term, def);
                          }),
                      FloatingActionButton(
                        child: const Icon(Icons.chevron_right),
                        onPressed: () => cardController.triggerSwipeRight(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

void addToStatsWrongAnswer(context, setName, uid, term, def) {
  BlocProvider.of<StatsCubit>(context).updateStats(
      stats: StatsEntity(
          set: setName,
          //amount: currentPage,
          uid: uid,
          term: term,
          def: def));
}

Widget buildCard(screenWidth, screenHeight, textFront, textBack, index) {
  final heroTag = 'cardHero_$index';
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
          width: screenWidth,
          height: screenHeight / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                textFront,
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
              textBack,
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
