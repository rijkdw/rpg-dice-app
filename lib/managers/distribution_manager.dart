import 'package:flutter/material.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/dice_engine/utils.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class DistributionManager extends ChangeNotifier {

  Map<int, Map<int, int>> _id2distributionMap;

  DistributionManager() {
    _id2distributionMap = {};
  }

  void createDistribution(DiceCollection diceCollection) {
    print('DistributionManager creating distribution for ${diceCollection.name}');
    Map<int, int> distribution = {};
    for (var i = 0; i < 10000; i++) {
      var value = Roller.roll(diceCollection.expression).total;
      if (!distribution.keys.contains(value)) {
        distribution[value] = 0;
      }
      distribution[value]++;
    }
    var mapKeys = distribution.keys.toList();
    mapKeys.sort();
    var newMap = <int, int>{};
    for (var key in mapKeys) {
      newMap[key] = distribution[key];
    }
    distribution = newMap;
    _id2distributionMap[diceCollection.id] = distribution;
    print('DistributionManager done creating distribution.');
    notifyListeners();
  }

  Map<int, int> getDistribution(int id) {
    if (!_id2distributionMap.keys.contains(id)) {
      return {};
    }
    return _id2distributionMap[id];
  }

  int getMaxOfDistribution(int id) {
    if (!_id2distributionMap.keys.contains(id)) {
      return 0;
    }
    return maxInList(_id2distributionMap[id].values);
  }

}