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
import 'package:awesome_dialog/awesome_dialog.dart';

class FlashcardsPage extends StatefulWidget {
  final SetEntity setEntity;
  final String uid;

  const FlashcardsPage({super.key, required this.setEntity, required this.uid});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  int currentPage = 0;
  int MAX_FLASHCARDS = 20;

  // bool isItFirstTime = true;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    BlocProvider.of<FlashcardCubit>(context)
        .getFlashcard(uid: widget.setEntity.name);
    super.initState();
    // _pageController.dispose();
    // _pageController = PageController(initialPage: 0);
    // currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "My flashcards",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          FloatingActionButton(
              heroTag: 'logg_out_from_flashcards',
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).loggedOut();
              },
              child: Icon(Icons.exit_to_app)),
          FloatingActionButton(
              heroTag: 'go_back_from_flashcards',
              onPressed: () {
                Navigator.pushNamed(context, PageConst.flahscardHomePage,
                    arguments: widget.uid);
              },
              child: Icon(Icons.arrow_back)),
        ],
      ),
      body: BlocBuilder<FlashcardCubit, FlashcardState>(
        builder: (context, flashcardState) {
          if (flashcardState is FlashcardLoaded) {
            // if (isItFirstTime) {
            //   // _initiateStats(flashcardState);
            // }
            return _bodyWidget(flashcardState);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // _initiateStats(FlashcardLoaded setLoadedState) {
  //   isItFirstTime = false;
  //   for (int i = 0; i < setLoadedState.flashcards.length; i++) {
  //     //final setEntity = setLoadedState.flashcards[i];
  //     BlocProvider.of<StatsCubit>(context).addStats(
  //         stats: StatsEntity(
  //             set: widget.setEntity.name,
  //             amount: 0,
  //             uid: widget.uid,
  //             term: setLoadedState.flashcards[i].term));
  //   }
  // }

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
                  back:
                      _buildCardSide("${setLoadedState.flashcards[index].def}"),
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
              heroTag: 'wrong_answer_button',
              onPressed: () {
                goToNextFlashcard();
                BlocProvider.of<StatsCubit>(context).updateStats(
                    stats: StatsEntity(
                        set: widget.setEntity.name,
                        amount: currentPage,
                        uid: widget.uid,
                        term: setLoadedState.flashcards[currentPage].term));
              },
              child: FaIcon(FontAwesomeIcons.xmark),
              backgroundColor: Colors.red,
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 'right_answear_button',
              onPressed: () {
                if (currentPage < MAX_FLASHCARDS) {
                  goToNextFlashcard();
                } else {
                  AwesomeDialog(
                      context: context,
                      showCloseIcon: false,
                      dismissOnTouchOutside: false,
                      title: "The end",
                      desc: 'You finished this flashcard set',
                      btnOkOnPress: () {
                        Navigator.pushNamed(
                            context, PageConst.flahscardHomePage,
                            arguments: widget.uid);
                      }).show();
                }
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
    // if (currentPage < MAX_FLASHCARDS) {
    //   _pageController.nextPage(
    //       duration: Duration(milliseconds: 1000), curve: Curves.easeInOut);
    // } else {
    //   AwesomeDialog(
    //       context: context,
    //       showCloseIcon: false,
    //       title: "The end",
    //       desc: 'You finished this flashcard set',
    //       btnOkOnPress: () {
    //         Navigator.pushNamed(context, PageConst.flahscardHomePage,
    //             arguments: widget.additionalParameter);
    //       }).show();
    //   //_endOfFlashcardsWidget(context, widget.additionalParameter);
    // }
  }
}

// AwesomeDialog _endOfFlashcardsWidget(context, arg) {
//   print("AAAAA");
//   return AwesomeDialog(
//       context: context,
//       showCloseIcon: false,
//       title: "The end",
//       desc: 'You finished this flashcard set',
//       btnOkOnPress: () {
//         Navigator.pushNamed(context, PageConst.flahscardHomePage,
//             arguments: arg);
//       }).show()
// }

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
