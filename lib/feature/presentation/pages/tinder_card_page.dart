// import 'package:flip_card/flip_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class TinderCard extends StatefulWidget {
//   const TinderCard({super.key});

//   @override
//   State<TinderCard> createState() => _TinderCardState();
// }

// class _TinderCardState extends State<TinderCard> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: buildFrontCard(),
//     );
//   }
// }

// Widget buildFrontCard() {
//   return GestureDetector(
//     child: buildCard(),
//     onPanStart: (details) {
//       final provider = Provider.of<CardProvider>(con)
//     },
//   );
// }

// Widget buildCard() {
//   return ClipRRect(
//       child: Card(
//     color: Colors.deepPurple,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(20),
//     ),
//     // margin: const EdgeInsets.all(30),
//     margin:
//         const EdgeInsets.only(left: 32.0, right: 32.0, top: 70.0, bottom: 70.0),
//     child: FlipCard(
//       direction: FlipDirection.HORIZONTAL,
//       front: _buildCardSide("term"),
//       back: _buildCardSide("def"),
//     ),
//   ));
// }

// Widget _buildCardSide(String text) {
//   return Container(
//     width: 300,
//     height: 100,
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Text(
//           text,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//       ],
//     ),
//   );
// }
