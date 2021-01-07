import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/home_screen/category_header.dart';
import 'package:rpg_dice/components/home_screen/dice_collection_listtile.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class DiceCollectionListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ScrollController listViewController = ScrollController();

    return Consumer<CollectionManager>(
      builder: (context, collectionManager, child) {
        var listTiles = collectionManager.diceCollections
            .map((col) => DiceCollectionListTile(
                  diceCollection: col,
                ))
            .toList();
        // var listTiles = <Widget>[];
        // for (var item in collectionManager.categoriesAndCollections) {
        //   if (item is Map) {
        //     var id = item['id'];
        //     var name = item['name'];
        //     listTiles.add(CategoryHeader(id, name));
        //   } else {
        //     listTiles.add(DiceCollectionListTile(diceCollection: item));
        //   }
        // }
        return Theme(
          data: ThemeData(
            highlightColor: Provider.of<ThemeManager>(context).theme.listViewScrollBarColor,
          ),
          child: Scrollbar(
            controller: listViewController,
            isAlwaysShown: true,
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: ListView(
                controller: listViewController,
                children: listTiles,
              ),
            ),
          ),
        );
      },
    );
  }
}
