import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/feature/presentation/cubit/auth/auth_cubit.dart';
import '../../../app_const.dart';
import '../cubit/set/set_cubit.dart';

import '../widgets/body_home_page.dart';

class FlashcardHomePage extends StatefulWidget {
  final String uid;
  const FlashcardHomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<FlashcardHomePage> createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  bool isItFirstTime = true;
  List<IconData> iconDataList = [
    FontAwesomeIcons.peopleGroup,
    FontAwesomeIcons.briefcase,
    FontAwesomeIcons.volleyball,
    FontAwesomeIcons.burger,
  ];
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
            return bodyWidgetHomePage(flashcardState, iconDataList, widget);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
