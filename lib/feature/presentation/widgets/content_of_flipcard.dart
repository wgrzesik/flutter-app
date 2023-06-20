import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

contentOfFlipCard(text, index) {
  return Column(children: [
    Expanded(
      flex: 1,
      child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text('${index + 1}/10',
                style: const TextStyle(color: Colors.white)),
          )),
    ),
    Expanded(
      flex: 5,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    ),
    const Expanded(
      flex: 1,
      child: Align(
          alignment: Alignment.center,
          child: Text('Click to flip', style: TextStyle(color: Colors.white))),
    ),
  ]);
}
