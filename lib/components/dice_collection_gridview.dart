import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/dice_collection_gridtile.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';

class DiceCollectionGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;
    var viewController = ScrollController();

    return Consumer<CollectionManager>(
      builder: (context, collectionManager, child) {
        var gridTiles = collectionManager.diceCollections
            .map((col) => DiceCollectionGridTile(
                  diceCollection: col,
                ))
            .toList();
        return Theme(
          data: ThemeData(
            highlightColor: theme.listViewScrollBarColor,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Scrollbar(
              controller: viewController,
              isAlwaysShown: true,
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: GridView.count(
                  controller: viewController,
                  crossAxisCount: 3,
                  children: gridTiles,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
