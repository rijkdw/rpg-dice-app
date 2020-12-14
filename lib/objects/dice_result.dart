import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/utils.dart';

class DiceResult {
  // ATTRIBUTES
  DiceCollection _diceCollection;
  List<int> _allOutcomes;
  List<int> _retainedOutcomes;
  int _constantModifier;

  // GETTERS
  DiceCollection get diceCollection => this._diceCollection;
  List<int> get allOutcomes => this._allOutcomes;
  List<int> get retainedOutcomes => this._retainedOutcomes;
  int get constantModifier => this._constantModifier;

  int get total => sumList(this._retainedOutcomes) + this._constantModifier;

  // SETTERS
}
