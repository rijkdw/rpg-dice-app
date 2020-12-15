import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpg_dice/components/dice_collection_menu_popup.dart';
import 'package:rpg_dice/components/dice_roller_popup.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class DiceCollectionListTile extends StatelessWidget {
  DiceCollection _diceCollection;

  DiceCollectionListTile({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  @override
  Widget build(BuildContext context) {
    void onTap() {
      showDialog(
        context: context,
        builder: (_) => DiceRollerPopup(
          diceCollection: this._diceCollection,
        ),
      );
    }

    void onLongPress() {
      showDialog(
        context: context,
        builder: (_) => DiceCollectionMenuPopup(),
      );
    }

    Widget leadingIcon = FaIcon(
      FontAwesomeIcons.diceD20,
      // size: 20,
      color: Theme.of(context).primaryColor,
    );

    // if no name
    if (this._diceCollection.name == null) {
      return ListTile(
        leading: leadingIcon,
        title: Text(this._diceCollection.expression),
        onTap: onTap,
        onLongPress: onLongPress,
      );
    } else {
      return ListTile(
        leading: leadingIcon,
        title: Text(this._diceCollection.name),
        // subtitle: Text(this._diceCollection.expression),
        onTap: onTap,
        onLongPress: onLongPress,
      );
    }
  }
}
