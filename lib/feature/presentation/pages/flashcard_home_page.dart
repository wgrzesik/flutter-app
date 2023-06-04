import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/feature/presentation/cubit/note/note_cubit.dart';
import 'package:intl/intl.dart';
import 'package:note_app/feature/presentation/cubit/auth/auth_cubit.dart';
import 'package:flip_card/flip_card.dart';

import '../../../app_const.dart';
import '../../../on_generate_route.dart';
import '../../domain/entities/set_entity.dart';
import '../cubit/set/set_cubit.dart';
import 'hero_dialog_route.dart';

class FlashcardHomePage extends StatefulWidget {
  final String uid;
  const FlashcardHomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<FlashcardHomePage> createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  @override
  void initState() {
    BlocProvider.of<SetCubit>(context).getSet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "My flashcards ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).loggedOut();
                Navigator.pushNamed(
                  context,
                  PageConst.signInPage,
                );
              },
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: BlocBuilder<SetCubit, SetState>(
        builder: (context, flashcardState) {
          if (flashcardState is SetLoaded) {
            return _bodyWidget(flashcardState);
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _noNotesWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Text("No sets here yet"),
        ],
      ),
    );
  }

  Widget _bodyWidget(SetLoaded setLoadedState) {
    return Column(
      children: [
        Expanded(
          child: setLoadedState.sets.isEmpty
              ? _noNotesWidget()
              : GridView.builder(
                  itemCount: setLoadedState.sets.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1.2),
                  itemBuilder: (_, index) {
                    final _todo = setLoadedState.sets[index];
                    final uidplusIndex = 'x';

                    return _TodoCard(
                        setEntity: _todo,
                        uidTodoCard: uidplusIndex,
                        index: index,
                        uid: widget.uid);
                  },
                ),
        ),
      ],
    );
  }
}

class _TodoCard extends StatelessWidget {
  final SetEntity setEntity;
  final String uidTodoCard;
  final int index;
  final String uid;

  const _TodoCard({
    required this.setEntity,
    required this.uidTodoCard,
    required this.index,
    required this.uid,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            HeroDialogRoute(
              builder: (context) => Center(
                child: _TodoPopupCard(
                  setEntity: setEntity,
                  uidTodoPopupCard: '${uidTodoCard}TPC$index',
                  index: index,
                  uid: uid,
                ),
              ),
            ),
          );
        },
        child: Hero(
          // tag: uidTodoCard + index.toString(),
          tag: '${uidTodoCard}TD$index',
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 2,
                              spreadRadius: 2,
                              offset: const Offset(0, 1.5))
                        ]),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(6),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text("${setEntity.name}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ])),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TodoPopupCard extends StatelessWidget {
  final SetEntity setEntity;
  final String uidTodoPopupCard;
  final int index;
  final String uid;

  const _TodoPopupCard({
    required this.setEntity,
    required this.uidTodoPopupCard,
    required this.index,
    required this.uid,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          // tag: uidTodoPopupCard + index.toString(),
          tag: '${uidTodoPopupCard}TPC$index',
          child: Material(
            //color: AppColors.accentColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  goToChoosenPage(
                                      context, PageConst.statisticsPage);
                                },
                                child: Text("Go to the statistics!",
                                    style: TextStyle(fontSize: 16)))),
                        Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  goToChoosenPage(
                                      context, PageConst.flashcardsPage);
                                },
                                child: Container(
                                    child: Text("Go to the set!",
                                        style: TextStyle(fontSize: 16))))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goToChoosenPage(BuildContext context, String pageConstName) {
    final arguments = FlashcardsPageArguments(setEntity, uid);
    Navigator.pushNamed(
      context,
      pageConstName,
      arguments: arguments,
    );
  }
}
