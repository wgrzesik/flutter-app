import 'package:flutter/material.dart';
import '../../../app_const.dart';
import '../../domain/entities/multiple_page_arguments.dart';
import '../../domain/entities/set_entity.dart';

class PopupCard extends StatelessWidget {
  final SetEntity setEntity;
  final String uidPopupCard;
  final int index;
  final String uid;

  const PopupCard({
    super.key,
    required this.setEntity,
    required this.uidPopupCard,
    required this.index,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: '$uidPopupCard$index',
          child: Material(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 2,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.purple.withOpacity(.5)),
                              child: const Text('Go to the statistics',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              onPressed: () {
                                goToChoosenPage(
                                    context, PageConst.buttonStatsPage);
                              }),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 2,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.indigo.withOpacity(.5)),
                              child: const Text('Go to the set',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              onPressed: () {
                                goToChoosenPage(context, PageConst.srsPage);
                              }),
                        ),
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
