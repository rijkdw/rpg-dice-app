import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/dice_engine/ast/objects/result.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/managers/history_manager.dart';

enum DiceCollectionIcon {
  D20,
  DICE,
  DRAGON,
  FIRE,
  WIZARD,
  HEART,
  FIRE_IN_HAND,
}

var diceCollectionIcon2IconDataMap = {
  DiceCollectionIcon.D20: FontAwesomeIcons.diceD20,
  DiceCollectionIcon.DICE: FontAwesomeIcons.dice,
  DiceCollectionIcon.DRAGON: FontAwesomeIcons.dragon,
  DiceCollectionIcon.FIRE: FontAwesomeIcons.fire,
  DiceCollectionIcon.WIZARD: FontAwesomeIcons.hatWizard,
  DiceCollectionIcon.HEART: FontAwesomeIcons.heart,
  DiceCollectionIcon.FIRE_IN_HAND: FontAwesomeIcons.handHoldingWater
};

class DiceCollection {

  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------

  String _name;
  String _expression;
  int _id;
  int _categoryID;

  // -------------------------------------------------------------------------------------------------
  // constructors
  // -------------------------------------------------------------------------------------------------

  DiceCollection({String name, String expression, int id=1, int categoryID=1}) {
    this._name = name;
    this._expression = expression;
    this._id = id;
    this._categoryID = categoryID;
  }

  // -------------------------------------------------------------------------------------------------
  // factories
  // -------------------------------------------------------------------------------------------------

  factory DiceCollection.dummy() {
    return DiceCollection(
      expression: '1d6',
      name: 'aaaaa',
      categoryID: 1,
    );
  }

  // -------------------------------------------------------------------------------------------------
  // functions
  // -------------------------------------------------------------------------------------------------

  Result roll({BuildContext context}) {
    var result = Roller.roll(_expression);
    if (context != null) {
      Provider.of<HistoryManager>(context, listen: false).addToHistory(_id, result);
    }
    return result;
  }

  // -------------------------------------------------------------------------------------------------
  // getters
  // -------------------------------------------------------------------------------------------------

  String get name => this._name;
  String get expression => this._expression;
  int get id => this._id;
  int get categoryID => this._categoryID;

  // -------------------------------------------------------------------------------------------------
  // setters
  // -------------------------------------------------------------------------------------------------

  set name(String newName) => this._name = newName;
  set expression(String newDice) => this._expression = newDice;
  set id(int newID) => this._id = newID;
  set categoryID(int newID) => this._categoryID = newID;

  // -------------------------------------------------------------------------------------------------
  // JSON
  // -------------------------------------------------------------------------------------------------

  factory DiceCollection.fromJson(Map<String, dynamic> jsonMap) {
    return DiceCollection(
      name: jsonMap['name'],
      expression: jsonMap['expression'],
      id: jsonMap['id'],
      categoryID: jsonMap['categoryID']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this._name,
      'expression': this._expression,
      'id': this._id,
      'categoryID': this._categoryID,
    };
  }
}
