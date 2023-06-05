import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app_const.dart';
import '../../../on_generate_route.dart';
import '../../domain/entities/multiple_page_arguments.dart';
import '../../domain/entities/set_entity.dart';

class TodoPopupCard extends StatelessWidget {
  final SetEntity setEntity;
  final String uidTodoPopupCard;
  final int index;
  final String uid;

  const TodoPopupCard({
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
                        Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  goToChoosenPage(context, PageConst.srsPage);
                                },
                                child: Container(
                                    child: Text("Go to the SRS!",
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
    final arguments = MultiplePageArguments(setEntity, uid);
    Navigator.pushNamed(
      context,
      pageConstName,
      arguments: arguments,
    );
  }
}
