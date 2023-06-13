import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cubit/stats/stats_cubit.dart';
import 'no_items_widget.dart';

Widget bodyWidgetAnswersStats(StatsLoaded statsLoadedState) {
  return Column(
    children: [
      Expanded(
          child: statsLoadedState.stats.isEmpty
              ? noItemsWidget('Nothing here')
              : ListView.builder(
                  itemCount: statsLoadedState.stats.length,
                  itemBuilder: (_, index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 84, 158, 158),
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
                            child: Text("${statsLoadedState.stats[index].term}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  }))
    ],
  );
}
