import 'package:flutter/material.dart';
import 'package:rpg_dice/dice_engine/ast/objects/result.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class HistoryManager extends ChangeNotifier {

  // attributes
  Map<int, List<Result>> _id2historyMap;

  // constructor
  HistoryManager() {
    _id2historyMap = <int, List<Result>>{};
  }

}