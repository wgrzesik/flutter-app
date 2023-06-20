import 'package:flutter/cupertino.dart';

import '../cubit/set/set_cubit.dart';
import 'grid_item.dart';

Widget bodyWidgetHomePage(SetLoaded setLoadedState, iconDataList, widget) {
  return Column(
    children: [
      Expanded(
        child: GridView.builder(
          itemCount: setLoadedState.sets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.8),
          itemBuilder: (_, index) {
            final setEntity = setLoadedState.sets[index];
            return GridItem(
              setEntity: setEntity,
              uidTodoCard: 'x',
              index: index,
              uid: widget.uid,
              iconName: iconDataList[index],
            );
          },
        ),
      ),
    ],
  );
}
