import 'package:flutter/material.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/dice_engine/utils.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class DistributionManager extends ChangeNotifier {

  Map<int, Map<int, int>> _id2distributionMap;

  DistributionManager() {
    _id2distributionMap = {};
  }

  void setDistribution(int id, Map<int, int> distribution) {
    _id2distributionMap[id] = distribution;
  }

  bool hasDistribution(int id) {
    return _id2distributionMap.containsKey(id);
  }

  Map<int, int> getDistribution(int id) {
    if (!_id2distributionMap.keys.contains(id)) {
      return {};
    }
    return _id2distributionMap[id];
  }

}