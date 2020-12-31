import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/dice_engine/ast/objects/result.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/objects/dice_result.dart';

class DiceCollection {
  // ATTRIBUTES
  String _name;
  String _expression;
  int _id;

  // CONSTRUCTORS
  DiceCollection({String name, String expression, int id=1}) {
    this._name = name;
    this._expression = expression;
    this._id = id;
  }

  Result roll({BuildContext context}) {
    var result = Roller.roll(_expression);
    if (context != null) {
      Provider.of<HistoryManager>(context, listen: false).addToHistory(_id, result);
    }
    return result;
  }

  // FUNCTIONS

  // GETTERS
  String get name => this._name;
  String get expression => this._expression;
  int get id => this._id;

  // SETTERS
  set name(String newName) => this._name = newName;
  set expression(String newDice) => this._expression = newDice;
  set id(int newID) => this._id = newID;

  // JSON
  factory DiceCollection.fromJson(Map<String, dynamic> jsonMap) {
    return DiceCollection(
      name: jsonMap["name"],
      expression: jsonMap["expression"],
      id: jsonMap["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this._name,
      "expression": this._expression,
      "id": this._id,
    };
  }
}
