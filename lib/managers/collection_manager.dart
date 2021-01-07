import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionManager extends ChangeNotifier {

  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------

  Map<int, DiceCollection> _diceCollectionsMap = {};
  Map<int, String> _id2categoryNameMap = {1: 'unassigned'};

  // -------------------------------------------------------------------------------------------------
  // constructors & factories
  // -------------------------------------------------------------------------------------------------

  CollectionManager() {
    print('Constructing a CollectionManager');
    this._loadFromLocal();
    print('Finished constructing a CollectionManager');
  }

  // -------------------------------------------------------------------------------------------------
  // collections
  // -------------------------------------------------------------------------------------------------

  int getNewCollectionID() {
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
      diceCollection.id = getNewCollectionID();
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
  
  // -------------------------------------------------------------------------------------------------
  // categories
  // -------------------------------------------------------------------------------------------------

  int getNewCategoryID() {
    /**
     * Get the lowest unused ID.
     */
    List<int> allCurrentIDs = _id2categoryNameMap.keys.toList();
    int targetID = 1;
    while (true) {
      // if the ID is unreserved, return it
      if (!allCurrentIDs.contains(targetID)) return targetID;
      // else add one and look again
      targetID++;
    }
  }

  void createCategory(String name) {
    var id = getNewCategoryID();
    _id2categoryNameMap[id] = name;
  }

  void deleteCategory(int id) {
    _id2categoryNameMap.remove(id);
    // set all collections with the removed ID to the unassigned category
    for (var collection in diceCollections) {
      if (collection.categoryID == id) collection.categoryID = 1;
    }
    notifyListeners();
  }

  // -------------------------------------------------------------------------------------------------
  // storage
  // -------------------------------------------------------------------------------------------------

  static const String _COLLECTIONS_KEY = 'dice_collections';
  static const String _CATEGORY_NAMES_KEY = 'category_names';

  Future _loadFromLocal() async {
    print('CollectionManager._loadFromLocal() is starting.');
    var prefs = await SharedPreferences.getInstance();

    // collections
    // fetch list of maps from local storage
    List<dynamic> diceCollectionMapList = json.decode(prefs.getString(_COLLECTIONS_KEY) ?? '[]');
    // for each map, make a DiceCollection object and add it with its id to the Manager's map
    diceCollectionMapList.forEach((map) {
      DiceCollection diceCollection = DiceCollection.fromJson(map);
      this._diceCollectionsMap[diceCollection.id] = diceCollection;
    });

    // categories
    _id2categoryNameMap = Map<int, String>.from(json.decode(prefs.getString(_CATEGORY_NAMES_KEY) ?? '{}'));
    _id2categoryNameMap[1] = 'unassigned';
    print('CollectionManager._loadFromLocal() has finished.');
    this.notifyListeners();
  }

  void _storeInLocal() async {
    print('CollectionManager._storeInLocal() is starting.');
    var prefs = await SharedPreferences.getInstance();
    // collections
    prefs.setString(_COLLECTIONS_KEY, json.encode(this.diceCollections.map((dc) => dc.toJson()).toList()));
    // categories
    // prefs.setString(_CATEGORY_NAMES_KEY, json.encode(_id2categoryNameMap)); // TODO
    print('CollectionManager._storeInLocal() has finished.');
  }

  // -------------------------------------------------------------------------------------------------
  // getters
  // -------------------------------------------------------------------------------------------------
  
  List<DiceCollection> get diceCollections => this._diceCollectionsMap.values.toList();

  List<dynamic> get categoriesAndCollections {
    var returnList = [];
    for (var categoryID in _id2categoryNameMap.keys) {
      var categoryMap = {'id': categoryID, 'name': _id2categoryNameMap[categoryID]};
      returnList.add(categoryMap);
      var listInThisCategory = diceCollections.where((collection) => collection.categoryID == categoryID).toList();
      returnList.addAll(listInThisCategory);
    }
    return returnList;
  }
}
