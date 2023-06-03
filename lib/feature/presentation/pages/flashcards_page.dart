import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_const.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../../domain/entities/set_entity.dart';
import '../../domain/entities/stats_entity.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/flashcard/flashcard_cubit.dart';
import '../cubit/stats/stats_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlashcardsPage extends StatefulWidget {
  final SetEntity setEntity;
  final String additionalParameter;

  const FlashcardsPage(
      {super.key, required this.setEntity, required this.additionalParameter});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  int currentPage = 0;
  PageController _pageController = new PageController(initialPage: 0);

  @override
  void initState() {
    BlocProvider.of<FlashcardCubit>(context).getSet(uid: widget.setEntity.name);
    super.initState();
    _pageController.dispose();
    currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My flashcards",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).loggedOut();
              },
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: BlocBuilder<FlashcardCubit, FlashcardState>(
        builder: (context, flashcardState) {
          if (flashcardState is FlashcardLoaded) {
            return _bodyWidget(flashcardState);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _bodyWidget(FlashcardLoaded setLoadedState) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 4,
          child: PageView.builder(
            itemCount: setLoadedState.flashcards.length,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Card(
                //color: const Color(0xFF006666),
                color: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.only(
                    left: 32.0, right: 32.0, top: 20.0, bottom: 0.0),
                child: FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  front: _buildCardSide(
                      "${setLoadedState.flashcards[index].term}"),
                  back: _buildCardSide(
                      "${setLoadedState.flashcards[index].definition}"),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            FloatingActionButton(
              onPressed: () {
                goToNextFlashcard();
                BlocProvider.of<StatsCubit>(context).addStats(
                    stats: StatsEntity(
                        set: widget.setEntity.name,
                        amount: currentPage,
                        uid: widget.additionalParameter,
                        term: setLoadedState.flashcards[currentPage].term));
              },
              child: FaIcon(FontAwesomeIcons.xmark),
              backgroundColor: Colors.red,
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: () {
                goToNextFlashcard();
              },
              child: FaIcon(Icons.check),
              backgroundColor: Colors.green,
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
        Expanded(
          flex: 1,
          child: Container(),
        )
      ],
    );
  }

  void goToNextFlashcard() {
    _pageController.nextPage(
        duration: Duration(milliseconds: 1000), curve: Curves.easeInOut);
  }
}

Widget _buildCardSide(String text) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    ],
  );
}
