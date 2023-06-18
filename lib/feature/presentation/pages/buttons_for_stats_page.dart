import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../app_const.dart';
import '../../domain/entities/multiple_page_arguments.dart';
import '../../domain/entities/set_entity.dart';

class ButtonStatsPage extends StatefulWidget {
  final SetEntity setEntity;
  final String uid;
  const ButtonStatsPage({Key? key, required this.setEntity, required this.uid})
      : super(key: key);

  @override
  State<ButtonStatsPage> createState() => _ButtonStatsPageState();
}

class _ButtonStatsPageState extends State<ButtonStatsPage> {
  @override
  Widget build(BuildContext context) {
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
            height: 100,
          ),
          FaIcon(FontAwesomeIcons.chartPie,
              size: 150, color: Color.fromARGB(255, 131, 69, 141)),
          SizedBox(
            height: 100,
          ),
          SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.withOpacity(.5)),
                child: const Text('Masterd',
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
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.withOpacity(.5)),
                child: const Text('Still learing',
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
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.withOpacity(.5)),
                child: const Text('Not studied',
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
