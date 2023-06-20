import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'content_of_flipcard.dart';

Widget buildFlashcard(String term, String def, int index) {
  final heroTag = 'flashcardHero_$index';
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Hero(
      tag: heroTag,
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        front: SizedBox(
          child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF006666),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: contentOfFlipCard(term, index)),
        ),
        back: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 52, 153, 153),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: contentOfFlipCard(def, index)),
      ),
    ),
  );
}
