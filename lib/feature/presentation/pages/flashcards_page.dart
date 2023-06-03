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
            child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: setLoadedState.flashcards.length,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(6),
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
            SizedBox(height: 20),
            Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.bounceOut);
                    print(currentPage);
                    BlocProvider.of<StatsCubit>(context).addStats(
                        stats: StatsEntity(
                            set: widget.setEntity.name,
                            amount: currentPage,
                            uid: widget.additionalParameter,
                            term: setLoadedState.flashcards[currentPage].term));
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.red,
                  ),
                ),
                // SizedBox(width: 20),
                // FloatingActionButton(
                //   onPressed: () {
                //     _pageController.nextPage(
                //         duration: Duration(milliseconds: 1000),
                //         curve: Curves.bounceOut);
                //   },
                //   child: Icon(Icons.arrow_forward, color: Colors.green),
                // ),
              ],
            )
          ],
        )),
      ],
    );
  }
}

Widget _buildCardSide(String text) {
  return Card(
    // elevation: 0.0,
    color: Color(0xFF006666),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
