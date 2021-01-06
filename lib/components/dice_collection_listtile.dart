import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/popups/dice_collection_menu_popup.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/screens/dice_roller_screen.dart';

// ignore: must_be_immutable
class DiceCollectionListTile extends StatelessWidget {
  DiceCollection diceCollection;

  DiceCollectionListTile({@required this.diceCollection});

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;

    void onTap() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return DiceRollerScreen(
          diceCollection: diceCollection,
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
          diceCollection: diceCollection,
        ),
      );
    }

    var titleTextStyle = TextStyle(
      // fontWeight: FontWeight.bold,
      color: theme.listTileTitleTextColor,
    );

    var subtitleTextStyle = TextStyle(
      color: theme.listTileSubtitleTextColor,
    );

    var leadingIcon = FaIcon(
      FontAwesomeIcons.diceD20,
      size: 36,
      color: theme.listTileIconColor,
    );

    // if no name
    if (diceCollection.name == null) {
      return ListTile(
        leading: Center(
          child: leadingIcon,
        ),
        title: Text(diceCollection.expression, style: titleTextStyle),
        onTap: onTap,
        onLongPress: onLongPress,
      );
    } else {
      return ListTile(
        leading: leadingIcon,
        title: Text(diceCollection.name /*+ '  (${_diceCollection.id})'*/, style: titleTextStyle),
        subtitle: Text(diceCollection.expression, style: subtitleTextStyle),
        onTap: onTap,
        onLongPress: onLongPress,
      );
    }
  }
}
