import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';
import 'package:rpg_dice/popups/create_new_dice_collection_popup.dart';

class DiceCollectionMenuPopup extends StatelessWidget {
  DiceCollection _diceCollection;

  DiceCollectionMenuPopup({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  @override
  Widget build(BuildContext context) {
    MyAppTheme theme = Provider.of<ThemeManager>(context).theme;

    Widget editMenuItem = _MenuListTile(
      iconData: FontAwesomeIcons.wrench,
      text: "Edit",
      onTap: () {
        // close this popup
        Navigator.of(context).pop();
        // open the other dialog
        showDialog(
          context: context,
          builder: (context) {
            return CreateNewDiceCollectionPopup(
              diceCollection: _diceCollection,
            );
          }
        );
      },
    );

    Widget deleteMenuItem = _MenuListTile(
      iconData: FontAwesomeIcons.trash,
      text: "Delete",
      onTap: () {
        // delete
        Provider.of<CollectionManager>(context, listen: false).deleteCollection(this._diceCollection.id);
        // close this popup
        Navigator.of(context).pop();
      },
    );

    return Dialog(
      elevation: 0,
      backgroundColor: theme.menuPopupBackgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              this._diceCollection.name ?? "Unnamed hand",
              style: TextStyle(fontSize: 30, color: theme.menuPopupListTileTextColor),
            ),
            SizedBox(height: 8),
            Text(
              this._diceCollection.expression,
              style: TextStyle(fontSize: 24, color: theme.menuPopupListTileTextColor),
            ),
            SizedBox(height: 8),
            Divider(thickness: 2, color: theme.menuPopupListTileDividerColor),
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
    MyAppTheme theme = Provider.of<ThemeManager>(context).theme;

    return ListTile(
      onTap: this._onTap,
      leading: Icon(
        this._iconData,
        color: theme.menuPopupListTileIconColor,
      ),
      title: Text(
        this._text,
        style: TextStyle(color: theme.menuPopupListTileTextColor),
      ),
    );
  }
}
