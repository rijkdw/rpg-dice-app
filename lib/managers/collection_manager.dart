import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionManager extends ChangeNotifier {
  // ATTRIBUTES
  Map<int, DiceCollection> _diceCollectionsMap = {};

  // CONSTRUCTORS
  CollectionManager() {
    print("Constructing a CollectionManager");
    this._loadFromLocal();
    print("Finished constructing a CollectionManager");
  }

  // FUNCTIONS

  int getNewID() {
    /**
     * Get the lowest unused ID.
     */
    List<int> allCurrentIDs = _diceCollectionsMap.keys.toList();
    int targetID = 1;
    while (true) {
      // if the ID is unreserved, return it
      if (!allCurrentIDs.contains(targetID)) return targetID;
      // else add one and look again
      targetID++;
    }
  }

  void addToCollections(DiceCollection diceCollection) {
    // make sure the ID is not used
    if (_diceCollectionsMap.containsKey(diceCollection.id)) {
      diceCollection.id = getNewID();
    }
    _diceCollectionsMap[diceCollection.id] = diceCollection;
    // commit to storage
    _storeInLocal();
    // reset views
    notifyListeners();
  }

  void editCollection(int oldID, DiceCollection newDiceCollection) {
    _diceCollectionsMap[oldID] = newDiceCollection;
    // commit to storage
    _storeInLocal();
    // reset views
    notifyListeners();
  }

  DiceCollection getCollection(int id) {
    if (!_diceCollectionsMap.keys.contains(id)) {
      return null;
    }
    return _diceCollectionsMap[id];
  }

  void deleteCollection(int id) {
    print('CollectionManager deleting collection with id=$id');
    this._diceCollectionsMap.remove(id);
    // commit to storage
    _storeInLocal();
    // reset views
    notifyListeners();
  }

  void deleteAll() {
    _diceCollectionsMap = {};
    notifyListeners();
  }

  // STORAGE

  final String _keyCollectionStorage = "dice_collections";

  Future _loadFromLocal() async {
    print("CollectionManager._loadFromLocal() is starting.");
    // fetch list of maps from local storage
    var prefs = await SharedPreferences.getInstance();
    List<dynamic> diceCollectionMapList = json.decode(prefs.getString(_keyCollectionStorage) ?? '[]');

    // for each map, make a DiceCollection object and add it with its id to the Manager's map
    diceCollectionMapList.forEach((map) {
      DiceCollection diceCollection = DiceCollection.fromJson(map);
      this._diceCollectionsMap[diceCollection.id] = diceCollection;
    });
    print("CollectionManager._loadFromLocal() has finished.");
    this.notifyListeners();
  }

  void _storeInLocal() async {
    print("CollectionManager._storeInLocal() is starting.");
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyCollectionStorage, json.encode(this.diceCollections.map((dc) => dc.toJson()).toList()));
    print("CollectionManager._storeInLocal() has finished.");
  }

  // GETTERS
  List<DiceCollection> get diceCollections => this._diceCollectionsMap.values.toList();
}
