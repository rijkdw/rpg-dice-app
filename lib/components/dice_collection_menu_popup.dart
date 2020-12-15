import 'package:flutter/material.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class DiceCollectionMenuPopup extends StatelessWidget {

  DiceCollection _diceCollection;

  DiceCollectionMenuPopup({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      ),
    );
  }

}