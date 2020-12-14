import 'package:flutter/material.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class DiceCollectionListTile extends StatelessWidget {
  DiceCollection _diceCollection;

  DiceCollectionListTile({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this._diceCollection.name),
      subtitle: Text(this._diceCollection.dice),
      trailing: InkWell(
        child: Icon(Icons.more_vert),
        splashColor: Colors.transparent,
        onTap: () {},
      ),
    );
  }
}
