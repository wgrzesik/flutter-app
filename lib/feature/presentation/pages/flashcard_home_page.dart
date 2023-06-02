import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/feature/presentation/cubit/note/note_cubit.dart';
import 'package:intl/intl.dart';
import 'package:note_app/feature/presentation/cubit/auth/auth_cubit.dart';

import '../../../app_const.dart';
import '../cubit/set/set_cubit.dart';

class FlashcardHomePage extends StatefulWidget {
  final String uid;
  const FlashcardHomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<FlashcardHomePage> createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  @override
  void initState() {
    BlocProvider.of<SetCubit>(context).getSet(uid: 'nature');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My flashcards ",
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, PageConst.addNotePage,
              arguments: widget.uid);
        },
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
          Text("No flashcards here yet"),
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.updateNotePage,
                            arguments: setLoadedState.sets[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.2),
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  offset: Offset(0, 1.5))
                            ]),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${setLoadedState.sets[index].term}",
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
