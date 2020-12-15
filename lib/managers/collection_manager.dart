import 'package:flutter/material.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class CollectionManager extends ChangeNotifier {
  // ATTRIBUTES
  Map<int, DiceCollection> _diceCollectionsMap = {};

  // CONSTRUCTORS
  CollectionManager() {
    print("Constructing a CollectionManager");
    this._loadFromLocal();
    this.notifyListeners();
    print("Finished constructing a CollectionManager");
  }

  // STORAGE
  Future _loadFromLocal() async {
    await Future.delayed(Duration(seconds: 1));
    this._diceCollectionsMap = {
      1: DiceCollection(id: 1, dice: "1d20"),
      2: DiceCollection(id: 2, name: "Fireball damage", dice: "8d6"),
      3: DiceCollection(id: 1, dice: "1d20"),
      4: DiceCollection(id: 2, name: "Fireball damage", dice: "8d6"),
      5: DiceCollection(id: 1, dice: "1d20"),
      6: DiceCollection(id: 2, name: "Fireball damage", dice: "8d6"),
      7: DiceCollection(id: 1, dice: "1d20"),
      8: DiceCollection(id: 2, name: "Fireball damage", dice: "8d6"),
      9: DiceCollection(id: 1, dice: "1d20"),
      10: DiceCollection(id: 2, name: "Fireball damage", dice: "8d6"),
      11: DiceCollection(id: 1, dice: "1d20"),
      12: DiceCollection(id: 2, name: "Fireball damage", dice: "8d6"),
      13: DiceCollection(id: 1, dice: "1d20"),
      14: DiceCollection(id: 2, name: "Fireball damage", dice: "8d6"),
    };
    this.notifyListeners();
  }

  void _storeInLocal() {}

  // GETTERS
  List<DiceCollection> get diceCollections => this._diceCollectionsMap.values.toList();
}
