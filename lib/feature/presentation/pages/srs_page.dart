import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/feature/presentation/cubit/flashcard/flashcard_cubit.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import '../../../app_const.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../../domain/entities/multiple_page_arguments.dart';
import '../../domain/entities/set_entity.dart';
import '../widgets/add_to_stats_correct_answers.dart';
import '../widgets/build_flashcard.dart';
import '../widgets/add_to_stats_wrong_answer.dart';

class SrsPage extends StatefulWidget {
  final SetEntity setEntity;
  final String uid;

  const SrsPage({super.key, required this.uid, required this.setEntity});

  @override
  State<SrsPage> createState() => _SrsPageState();
}

class _SrsPageState extends State<SrsPage> with TickerProviderStateMixin {
  SwipeableCardSectionController? cardController;
  String? setName;
  String? uid;
  int current = 0;
  int goodAnswers = 0;
  int badAnswers = 0;

  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {});
    final flashcardCubit = BlocProvider.of<FlashcardCubit>(context);
    flashcardCubit.srs(uid: widget.uid, setName: widget.setEntity.name);
    cardController = SwipeableCardSectionController();
    setName = widget.setEntity.name!;
    uid = widget.uid;
    current = 0;
    goodAnswers = 0;
    badAnswers = 0;
  }

  @override
  void dispose() {
    _ticker.dispose();
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
            cardController?.enableSwipe(true);
            cardController?.enableSwipeListener(false);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "${widget.setEntity.name} flashcards",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<FlashcardCubit, FlashcardState>(
        builder: (context, flashcardStateSrs) {
          if (flashcardStateSrs is FlashcardLoaded) {
            final List<FlashcardEntity> listOfStatsEntitySrs =
                flashcardStateSrs.flashcards;
            return _bodyWidget(
                context, listOfStatsEntitySrs, cardController!, setName!, uid!);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _bodyWidget(
    BuildContext context,
    final List<FlashcardEntity> listOfStatsEntity,
    SwipeableCardSectionController cardController,
    String setName,
    String uid,
  ) {
    final List<Widget> flashcards = [];
    for (int index = 0; index < 10; index++) {
      final FlashcardEntity stat = listOfStatsEntity[index];
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
            if (mounted) {
              setState(() {
                current = index;
              });
            }
            if (index < restOfItems.toList().length) {
              cardController.addItem(restOfItems[index]);
            }

            if (index == 9) {
              // go to the end page that shows the amount of good and bad answers
              final arguments = MultiplePageArgumentsSetName(
                  setName, uid, badAnswers, goodAnswers);
              Navigator.pushNamed(
                context,
                PageConst.endOfFlashcardsPage,
                arguments: arguments,
              );
              cardController.enableSwipe(true);
              cardController.enableSwipeListener(false);
            }
            if (dir == Direction.left) {
              addToStatsWrongAnswer(
                context,
                setName,
                uid,
                listOfStatsEntity[current].term!,
                listOfStatsEntity[current].def!,
              );
              if (mounted) {
                setState(() {
                  badAnswers += 1;
                });
              }
            } else if (dir == Direction.right) {
              addToStatsCorrectAnswer(
                  context,
                  setName,
                  uid,
                  listOfStatsEntity[current].term!,
                  listOfStatsEntity[current].def!);
              if (mounted) {
                setState(() {
                  goodAnswers += 1;
                });
              }
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
}
