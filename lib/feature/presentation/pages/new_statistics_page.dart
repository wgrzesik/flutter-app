// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../app_const.dart';
// import '../../domain/entities/set_entity.dart';
// import '../../domain/entities/stats_entity.dart';
// import '../cubit/stats/stats_cubit.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// class NewStatisticsPage extends StatefulWidget {
//   final SetEntity setEntity;
//   final String uid;
//   const NewStatisticsPage({required this.setEntity, required this.uid});

//   @override
//   State<NewStatisticsPage> createState() => _NewStatisticsPageState();
// }

// class _NewStatisticsPageState extends State<NewStatisticsPage> {
//   @override
//   void initState() {
//     BlocProvider.of<StatsCubit>(context)
//         .getStats(uid: widget.uid, setName: widget.setEntity.name);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pushNamed(
//               context,
//               PageConst.flahscardHomePage,
//               arguments: widget.uid,
//             );
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//         title: Text(
//           "${widget.setEntity.name} statistics",
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: BlocBuilder<StatsCubit, StatsState>(
//         builder: (context, flashcardState) {
//           if (flashcardState is StatsLoaded) {
//             final List<StatsEntity> listOfStatsEntity = flashcardState.stats;
//             return _bodyWidget(context, listOfStatsEntity);
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }

// Widget _bodyWidget(BuildContext context, List<StatsEntity> listOfStatsEntity) {
//   final List<StatsData> statistics = [];

//   for (int index = 0; index < 10; index++) {
//     final StatsEntity stat = listOfStatsEntity[index];
//     final stats = StatsData(stat.term!, stat.amount!);
//     statistics.add(stats);
//   }
//   return SafeArea(
//     child: child);
// }

// class StatsData {
//   StatsData(this.term, this.amount);

//   final String term;
//   final int amount;
// }

// // return Column(children: [
// //     //Initialize the chart widget
// //     SfCartesianChart(
// //         primaryXAxis: CategoryAxis(),
// //         // Chart title
// //         title: ChartTitle(text: 'Half yearly sales analysis'),
// //         // Enable legend
// //         legend: Legend(isVisible: true),
// //         // Enable tooltip
// //         tooltipBehavior: TooltipBehavior(enable: true),
// //         series: <ChartSeries<StatsData, String>>[
// //           LineSeries<StatsData, String>(
// //               dataSource: statistics,
// //               xValueMapper: (StatsData sales, _) => sales.term,
// //               yValueMapper: (StatsData sales, _) => sales.amount,
// //               name: 'Stats',
// //               // Enable data label
// //               dataLabelSettings: DataLabelSettings(isVisible: true))
// //         ]),
// //     Expanded(
// //       child: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         //Initialize the spark charts widget
// //         child: SfSparkLineChart.custom(
// //           //Enable the trackball
// //           trackball:
// //               SparkChartTrackball(activationMode: SparkChartActivationMode.tap),
// //           //Enable marker
// //           marker:
// //               SparkChartMarker(displayMode: SparkChartMarkerDisplayMode.all),
// //           //Enable data label
// //           labelDisplayMode: SparkChartLabelDisplayMode.all,
// //           xValueMapper: (int index) => statistics[index].term,
// //           yValueMapper: (int index) => statistics[index].amount,
// //           dataCount: 5,
// //         ),
// //       ),
// //     )
// //   ]);