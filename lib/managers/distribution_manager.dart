import 'package:flutter/material.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class DistributionManager extends ChangeNotifier {

  Map<int, Map<int, int>> _id2distributionMap;

  DistributionManager() {
    _id2distributionMap = {};
  }

  void createDistribution(DiceCollection diceCollection) {
    Map<int, int> distribution = {};
    for (var i = 0; i < 10000; i++) {
      var value = Roller.roll(diceCollection.expression).total;
      if (!distribution.keys.contains(value)) {
        distribution[value] = 0;
      }
      distribution[value]++;
    }
    _id2distributionMap[diceCollection.id] = distribution;
    notifyListeners();
  }

  Map<int, int> getDistribution(int id) {
    if (!_id2distributionMap.keys.contains(id)) {
      return {};
    }
    return _id2distributionMap[id];
  }

}