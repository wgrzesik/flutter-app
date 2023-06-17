import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../app_const.dart';

class EndOfFlashcardsPage extends StatefulWidget {
  final String setName;
  final String uid;
  final int badAnswers;
  final int goodAnswers;

  const EndOfFlashcardsPage(
      {super.key,
      required this.setName,
      required this.uid,
      required this.badAnswers,
      required this.goodAnswers});

  @override
  State<EndOfFlashcardsPage> createState() => _EndOfFlashcardsPageState();
}

class _EndOfFlashcardsPageState extends State<EndOfFlashcardsPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Know": widget.goodAnswers.toDouble(),
      "Still learning": widget.badAnswers.toDouble(),
    };
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
          title: Text(
            "${widget.setName} flashcards",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              ),
              const FaIcon(FontAwesomeIcons.hatWizard, size: 50),
              const SizedBox(height: 20),
              const Text(
                "Great job!",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Keep focusing on your tough terms!",
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
              PieChart(
                dataMap: dataMap,
                chartRadius: MediaQuery.of(context).size.width / 3,
                colorList: [
                  // Color.fromARGB(255, 226, 73, 193),
                  // Color.fromARGB(255, 73, 128, 75),
                  Colors.purple.withOpacity(.8),
                  Colors.indigo.withOpacity(.8)
                ],
                chartValuesOptions: const ChartValuesOptions(
                  showChartValuesInPercentage: true,
                ),
                // legendOptions: LegendOptions(
                //     legendTextStyle: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ));
  }
}

          // child: Card(
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(8.0),
          //   ),
          //   child: SizedBox(
          //     child: Container(
          //       decoration: const BoxDecoration(
          //         color: Color(0xFF006666),
          //         borderRadius: BorderRadius.all(Radius.circular(8.0)),
          //       ),
          //       child: Column(
          //         children: [
          //           SizedBox(
          //             height: MediaQuery.of(context).size.height / 4,
          //           ),
          //           FaIcon(FontAwesomeIcons.hatWizard, size: 50),
          //           Text(
          //             "You're doing great!",
          //             style: const TextStyle(
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 24,
          //             ),
          //           ),
          //           Text(
          //             "Keep focusing\non your tough terms!",
          //             style: const TextStyle(
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 24,
          //             ),
          //           ),
          //           SizedBox(height: 50),
          //           PieChart(
          //             dataMap: dataMap,
          //             chartRadius: MediaQuery.of(context).size.width / 3,
          //             colorList: [
          //               Color.fromARGB(255, 226, 73, 193),
          //               Color.fromARGB(255, 73, 128, 75),
          //             ],
          //             chartValuesOptions: ChartValuesOptions(
          //               showChartValuesInPercentage: true,
          //             ),
          //             legendOptions: LegendOptions(
          //                 legendTextStyle: TextStyle(color: Colors.white)),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),