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
              const FaIcon(FontAwesomeIcons.hatWizard, size: 60),
              const SizedBox(height: 20),
              const Text(
                "Great job!",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Keep focusing on your tough terms!",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
              PieChart(
                dataMap: dataMap,
                chartRadius: MediaQuery.of(context).size.width / 3,
                colorList: [
                  Colors.purple.withOpacity(.7),
                  const Color(0xFF006666).withOpacity(0.7)
                ],
                chartValuesOptions: const ChartValuesOptions(
                  showChartValuesInPercentage: true,
                ),
              )
            ],
          ),
        ));
  }
}
