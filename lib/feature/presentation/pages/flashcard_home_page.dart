import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/feature/presentation/cubit/note/note_cubit.dart';
import 'package:intl/intl.dart';
import 'package:note_app/feature/presentation/cubit/auth/auth_cubit.dart';
import 'package:flip_card/flip_card.dart';

import '../../../app_const.dart';
import '../cubit/set/set_cubit.dart';
import 'package:note_app/feature/presentation/widgets/todo_card.dart';

class FlashcardHomePage extends StatefulWidget {
  final String uid;
  const FlashcardHomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<FlashcardHomePage> createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  bool isItFirstTime = true;
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
        leading: const Center(
            child: Padding(
          padding: EdgeInsets.only(left: 40),
          child: FaIcon(FontAwesomeIcons.hatWizard),
        )),
        title: const Center(
          child: Text(
            "FlashcardWizard",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
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
              icon: const FaIcon(FontAwesomeIcons.rightFromBracket, size: 19)),
        ],
      ),
      body: BlocBuilder<SetCubit, SetState>(
        builder: (context, flashcardState) {
          if (flashcardState is SetLoaded) {
            return _bodyWidget(flashcardState);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _bodyWidget(SetLoaded setLoadedState) {
    return Column(
      children: [
        // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //   Text(
        //     'Hey, name!',
        //     style: TextStyle(fontSize: 16),
        //   ),
        //   Text('Explore Sets',
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
        // ]),
        Expanded(
          child: GridView.builder(
            itemCount: setLoadedState.sets.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1.2),
            itemBuilder: (_, index) {
              final todo = setLoadedState.sets[index];
              //const uidplusIndex = 'x';

              return TodoCard(
                  setEntity: todo,
                  uidTodoCard: 'x',
                  index: index,
                  uid: widget.uid);
            },
          ),
        ),
      ],
    );
  }
}
