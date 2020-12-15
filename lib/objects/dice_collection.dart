import 'package:rpg_dice/objects/dice_result.dart';

class DiceCollection {
  // ATTRIBUTES
  String _name;
  String _expression;
  int _id;

  // CONSTRUCTORS
  DiceCollection({String name, String dice, int id}) {
    this._name = name;
    this._expression = dice;
    this._id = id;
  }

  // FUNCTIONS
  // TODO

  // GETTERS
  String get name => this._name;
  String get expression => this._expression;
  int get id => this._id;

  // SETTERS
  set name(String newName) => this._name = newName;
  set expression(String newDice) => this._expression = newDice;
}
