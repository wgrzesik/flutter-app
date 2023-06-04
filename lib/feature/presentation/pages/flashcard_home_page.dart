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
import '../../domain/entities/stats_entity.dart';
import '../cubit/set/set_cubit.dart';
import '../cubit/stats/stats_cubit.dart';
import '../widgets/no_items_widget.dart';
import 'hero_dialog_route.dart';
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
        title: Text(
          "My sets",
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

  Widget _bodyWidget(SetLoaded setLoadedState) {
    return Column(
      children: [
        Expanded(
          child: setLoadedState.sets.isEmpty
              ? NoItemsWidget('No sets here yet')
              : GridView.builder(
                  itemCount: setLoadedState.sets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1.2),
                  itemBuilder: (_, index) {
                    final _todo = setLoadedState.sets[index];
                    final uidplusIndex = 'x';

                    return TodoCard(
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
