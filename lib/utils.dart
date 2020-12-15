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