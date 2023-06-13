import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/feature/domain/entities/stats_entity.dart';

import '../../../app_const.dart';
import '../../domain/entities/multiple_page_arguments.dart';
import '../../domain/entities/set_entity.dart';
import '../cubit/stats/stats_cubit.dart';

class ButtonStatsPage extends StatefulWidget {
  final SetEntity setEntity;
  final String uid;
  const ButtonStatsPage(
      {super.key, required this.setEntity, required this.uid});

  @override
  State<ButtonStatsPage> createState() => _ButtonStatsPageState();
}

class _ButtonStatsPageState extends State<ButtonStatsPage> {
  @override
  Widget build(BuildContext context) {
    String? setName = widget.setEntity.name;
    String? uid = widget.uid;
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
        title: const Text(
          "Your Statistics",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.withOpacity(.5)),
                child: const Text('Correct ',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                onPressed: () {
                  final arguments =
                      MultiplePageArguments(widget.setEntity, widget.uid);
                  Navigator.pushNamed(
                    context,
                    PageConst.correctAnswersPage,
                    arguments: arguments,
                  );
                }),
          ),
          SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.withOpacity(.5)),
                child: const Text('Wrong ',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                onPressed: () {
                  final arguments =
                      MultiplePageArguments(widget.setEntity, widget.uid);
                  Navigator.pushNamed(
                    context,
                    PageConst.wrongAnswersPage,
                    arguments: arguments,
                  );
                }),
          ),
          SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.withOpacity(.5)),
                child: const Text('No',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                onPressed: () {
                  final arguments =
                      MultiplePageArguments(widget.setEntity, widget.uid);
                  Navigator.pushNamed(
                    context,
                    PageConst.noAnswersPage,
                    arguments: arguments,
                  );
                }),
          ),
        ],
      )),
    );
  }
}
