import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpg_dice/components/menu_list_tile.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class DiceCollectionMenuPopup extends StatelessWidget {
  DiceCollection _diceCollection;

  DiceCollectionMenuPopup({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  @override
  Widget build(BuildContext context) {
    Widget editMenuItem = MenuListTile(
      iconData: FontAwesomeIcons.wrench,
      text: "Edit",
      onTap: () {},
    );

    Widget deleteMenuItem = MenuListTile(
      iconData: FontAwesomeIcons.trash,
      text: "Delete",
      onTap: () {},
    );

    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              this._diceCollection.name ?? "Unnamed hand",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 8),
            Text(
              this._diceCollection.expression,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Divider(thickness: 2),
            editMenuItem,
            deleteMenuItem,
          ],
        ),
      ),
    );
  }
}
