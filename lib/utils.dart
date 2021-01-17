import 'package:flutter/material.dart';
import 'dart:math';

int sumList(List<int> list) {
  int sum = 0;
  list.forEach((e) => sum += e);
  return sum;
}

double roundToNDecimals(double value, int n) {
  if (n < 0) return value;
  var valueXn = value*pow(10, n);
  var valueXnRounded = valueXn.round();
  var valueReturn = valueXnRounded / pow(10, n);
  return valueReturn;
}

List<Widget> intersperse(List<Widget> list, Widget Function() function) {
  if (list.isEmpty) return <Widget>[];
  List<Widget> listToReturn = [];
  for (Widget widget in list) {
    listToReturn.add(widget);
    listToReturn.add(function());
  }
  listToReturn.removeLast();
  return listToReturn;
}

String demarcateThousands(int value) {
  var valueStringReversed = reverseString('$value');
  var outputReversed = '';
  for (var i = 0; i < valueStringReversed.length; i++) {
    if (i > 0 && i % 3 == 0) {
      outputReversed += ',';
    }
    outputReversed += valueStringReversed[i];
  }
  return reverseString(outputReversed);
}

String reverseString(String input) {
  return String.fromCharCodes(input.codeUnits.reversed);
}

String toSentenceCase(String input) => input[0].toUpperCase() + input.substring(1).toLowerCase();

dynamic randomFromList(List list) {
  var random = Random();
  return list[random.nextInt(list.length)];
}

Map<dynamic, dynamic> sortMapKeys(Map<dynamic, dynamic> inMap) {
  var returnMap = {};
  var mapKeys = inMap.keys.toList();
  mapKeys.sort();
  for (var key in mapKeys) {
    returnMap[key] = inMap[key];
  }
  return returnMap;
}