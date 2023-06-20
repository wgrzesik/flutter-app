import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/feature/presentation/widgets/popup_card.dart';
import '../../domain/entities/set_entity.dart';
import 'package:note_app/feature/presentation/routes/hero_dialog_route.dart';

class GridItem extends StatelessWidget {
  final SetEntity setEntity;
  final String uidTodoCard;
  final int index;
  final String uid;
  final IconData iconName;

  const GridItem({
    super.key,
    required this.setEntity,
    required this.uidTodoCard,
    required this.index,
    required this.uid,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: PopupCard(
                setEntity: setEntity,
                uidPopupCard: '$uidTodoCard$index',
                index: index,
                uid: uid,
              ),
            ),
          ),
        );
      },
      child: Hero(
        tag: '${uidTodoCard}TD$index',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
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
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(6),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          iconName,
                          size: 60,
                          color: Colors.purple.withOpacity(0.3),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text("${setEntity.name}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ])),
            ),
          ),
        ),
      ),
    );
  }
}
