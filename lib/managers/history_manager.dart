import 'package:flutter/material.dart';
import 'package:rpg_dice/dice_engine/ast/objects/result.dart';

class HistoryManager extends ChangeNotifier {

  // attributes
  Map<int, List<Result>> _id2historyMap;

  // constructor
  HistoryManager() {
    _id2historyMap = <int, List<Result>>{};
  }

  void ensureKeyIsPresent(int id) {
    if (!_id2historyMap.keys.contains(id)) {
      _id2historyMap[id] = <Result>[];
    }
  }

  void addToHistory(int id, Result result) {
    ensureKeyIsPresent(id);
    _id2historyMap[id].insert(0, result);
    // _id2historyMap[id].add(result);
    notifyListeners();
  }

  List<Result> getResultsOfID(int id) {
    ensureKeyIsPresent(id);
    return _id2historyMap[id];
  }

  Result getLastResultOfID(int id) {
    ensureKeyIsPresent(id);
    if (_id2historyMap[id].isEmpty) return null;
    return _id2historyMap[id].first;
  }

  void clearHistory(int id) {
    _id2historyMap[id] = <Result>[];
    notifyListeners();
  }

}