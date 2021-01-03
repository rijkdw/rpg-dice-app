import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/popups/create_new_dice_collection_popup.dart';

class DiceCollectionInfo extends StatelessWidget {

  int id;
  DiceCollectionInfo({@required this.id});

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------------------------------
    // variables
    // -------------------------------------------------------------------------------------------------
    var theme = Provider.of<ThemeManager>(context).theme;
    var collectionManager = Provider.of<CollectionManager>(context);
    var diceCollection = collectionManager.getCollection(id) ?? DiceCollection.dummy();
    // -------------------------------------------------------------------------------------------------
    // return
    // -------------------------------------------------------------------------------------------------
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Info', style: TextStyle(
              color: theme.rollerCardHeadingColor,
              fontSize: 20,
            )),
            InkWell(
              child: Icon(
                FontAwesomeIcons.wrench,
                size: 20,
                color: theme.rollerCardHeadingColor,
              ),
              onTap: () {
                // open the other dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return CreateNewDiceCollectionPopup(
                      diceCollection: diceCollection,
                    );
                  },
                );
              },
              splashColor: Colors.transparent,
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${diceCollection.name}', style: TextStyle(
              fontSize: 18,
              color: theme.rollerNameAndExpressionColor,
            )),
            Text('${diceCollection.expression}', style: TextStyle(
              fontSize: 18,
              color: theme.rollerNameAndExpressionColor,
            )),
          ],
        ),
      ],
    );
  }
}
