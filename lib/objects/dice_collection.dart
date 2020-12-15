import 'package:rpg_dice/objects/dice_result.dart';

class DiceCollection {
  // ATTRIBUTES
  String _name;
  String _dice;
  int _id;

  // CONSTRUCTORS
  DiceCollection({String name, String dice, int id}) {
    this._name = name;
    this._dice = dice;
    this._id = id;
  }

  // FUNCTIONS
  // TODO

  // GETTERS
  String get name => this._name;
  String get dice => this._dice;
  int get id => this._id;

  // SETTERS
  set name(String newName) => this._name = newName;
  set dice(String newDice) => this._dice = newDice;
}
