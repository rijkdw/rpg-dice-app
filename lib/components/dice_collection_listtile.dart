import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/popups/dice_collection_menu_popup.dart';
import 'package:rpg_dice/popups/dice_roller_popup.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/screens/dice_roller_screen.dart';

// ignore: must_be_immutable
class DiceCollectionListTile extends StatelessWidget {
  DiceCollection _diceCollection;

  DiceCollectionListTile({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  @override
  Widget build(BuildContext context) {
    MyAppTheme theme = Provider.of<ThemeManager>(context).theme;

    void onTap() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return DiceRollerScreen(
          diceCollection: _diceCollection,
        );
      }));
      // showDialog(
      //   context: context,
      //   builder: (_) => DiceRollerPopup(
      //     diceCollection: this._diceCollection,
      //   ),
      // );
    }

    void onLongPress() {
      showDialog(
        context: context,
        builder: (_) => DiceCollectionMenuPopup(
          diceCollection: this._diceCollection,
        ),
      );
    }

    TextStyle titleTextStyle = TextStyle(
      // fontWeight: FontWeight.bold,
      color: theme.listTileTitleTextColor,
    );

    TextStyle subtitleTextStyle = TextStyle(
      color: theme.listTileSubtitleTextColor,
    );

    Widget leadingIcon = FaIcon(
      FontAwesomeIcons.diceD20,
      size: 36,
      color: theme.listTileIconColor,
    );

    // if no name
    if (this._diceCollection.name == null) {
      return ListTile(
        leading: Center(
          child: leadingIcon,
        ),
        title: Text(this._diceCollection.expression, style: titleTextStyle),
        onTap: onTap,
        onLongPress: onLongPress,
      );
    } else {
      return ListTile(
        leading: leadingIcon,
        title: Text(this._diceCollection.name, style: titleTextStyle),
        subtitle: Text(this._diceCollection.expression, style: subtitleTextStyle),
        onTap: onTap,
        onLongPress: onLongPress,
      );
    }
  }
}
