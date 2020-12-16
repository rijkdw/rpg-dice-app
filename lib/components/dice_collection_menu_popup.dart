import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class DiceCollectionMenuPopup extends StatelessWidget {
  DiceCollection _diceCollection;

  DiceCollectionMenuPopup({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  @override
  Widget build(BuildContext context) {
    Widget editMenuItem = _MenuListTile(
      iconData: FontAwesomeIcons.wrench,
      text: "Edit",
      onTap: () {},
    );

    Widget deleteMenuItem = _MenuListTile(
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

class _MenuListTile extends StatelessWidget {
  String _text;
  IconData _iconData;
  VoidCallback _onTap;

  _MenuListTile({String text, IconData iconData, VoidCallback onTap}) {
    this._text = text;
    this._iconData = iconData;
    this._onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: this._onTap,
      leading: Icon(
        this._iconData,
        color: Provider.of<ThemeManager>(context).theme.drawerBodyIconColor,
      ),
      title: Text(this._text),
    );
  }
}
