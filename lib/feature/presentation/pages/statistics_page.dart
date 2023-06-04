import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_const.dart';
import '../../domain/entities/set_entity.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/stats/stats_cubit.dart';

class StatisticsPage extends StatefulWidget {
  final SetEntity setEntity;
  final String additionalParameter;

  const StatisticsPage(
      {super.key, required this.setEntity, required this.additionalParameter});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    BlocProvider.of<StatsCubit>(context).getStats(
        uid: widget.additionalParameter, setName: widget.setEntity.name);
    print(widget.additionalParameter);
    print(widget.setEntity.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "My statistics",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).loggedOut();
              },
              icon: Icon(Icons.exit_to_app)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, PageConst.flahscardHomePage,
                    arguments: widget.additionalParameter);
              },
              icon: Icon(Icons.arrow_back)),
        ],
      ),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, flashcardState) {
          if (flashcardState is StatsLoaded) {
            return _bodyWidget(flashcardState);
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _bodyWidget(StatsLoaded statsLoadedState) {
    return Column(
      children: [
        Expanded(
          child: statsLoadedState.stats.isEmpty
              ? _noNotesWidget()
              : GridView.builder(
                  itemCount: statsLoadedState.stats.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1.2),
                  itemBuilder: (_, index) {
                    return Container(
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
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                                "${statsLoadedState.stats[index].term}: ${statsLoadedState.stats[index].amount}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
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
          Text("No stats here yet"),
        ],
      ),
    );
  }
}
