import 'package:flutter/material.dart';
import 'package:rpg_dice/components/dice_roller_popup.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class DiceCollectionListTile extends StatelessWidget {
  DiceCollection _diceCollection;

  DiceCollectionListTile({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  @override
  Widget build(BuildContext context) {
    void _onTap() {
      showDialog(
        context: context,
        builder: (_) => DiceRollerPopup(
          diceCollection: this._diceCollection,
        ),
      );
    }

    // if no name
    if (this._diceCollection.name == null) {
      return ListTile(
        title: Text(this._diceCollection.dice),
        onTap: _onTap,
      );
    } else {
      return ListTile(
        title: Text(this._diceCollection.name),
        subtitle: Text(this._diceCollection.dice),
        onTap: _onTap,
      );
    }
  }
}
