import 'package:flutter/material.dart';

int sumList(List<int> list) {
  int sum = 0;
  list.forEach((e) => sum += e);
  return sum;
}

List<Widget> intersperse(List<Widget> list, Widget Function() function) {
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