import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/popups/dice_collection_menu_popup.dart';
import 'package:rpg_dice/screens/dice_roller_screen.dart';

class DiceCollectionGridTile extends StatelessWidget {

  DiceCollection diceCollection;

  DiceCollectionGridTile({@required this.diceCollection});

  @override
  Widget build(BuildContext context) {

    // -------------------------------------------------------------------------------------------------
    // variables
    // -------------------------------------------------------------------------------------------------

    var theme = Provider.of<ThemeManager>(context).theme;

    // -------------------------------------------------------------------------------------------------
    // tap callbacks
    // -------------------------------------------------------------------------------------------------

    void onTap() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return DiceRollerScreen(
          diceCollection: diceCollection,
        );
      }));
    }

    void onLongPress() {
      showDialog(
        context: context,
        builder: (_) => DiceCollectionMenuPopup(
          diceCollection: diceCollection,
        ),
      );
    }

    // -------------------------------------------------------------------------------------------------
    // widgets & styles
    // -------------------------------------------------------------------------------------------------

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

    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              leadingIcon,
              SizedBox(height: 3),
              Text(
                diceCollection.name,
                style: titleTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3),
              Text(
                diceCollection.expression,
                style: subtitleTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
