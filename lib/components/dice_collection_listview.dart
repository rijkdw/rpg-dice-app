import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/dice_collection_listtile.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';

class DiceCollectionListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ScrollController listViewController = ScrollController();

    return Consumer<CollectionManager>(
      builder: (context, collectionManager, child) {
        List<Widget> listTiles = collectionManager.diceCollections
            .map((col) => DiceCollectionListTile(
                  diceCollection: col,
                ))
            .toList();
        return Theme(
          data: ThemeData(
            highlightColor: Provider.of<ThemeManager>(context).theme.listViewScrollBarColor,
          ),
          child: Scrollbar(
            controller: listViewController,
            isAlwaysShown: true,
            child: Container(
              decoration: BoxDecoration(
                color: Provider.of<ThemeManager>(context).theme.listViewBackgroundColor,
              ),
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: ListView(
                  controller: listViewController,
                  children: listTiles,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
