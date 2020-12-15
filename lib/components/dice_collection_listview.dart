import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/dice_collection_listtile.dart';
import 'package:rpg_dice/managers/collection_manager.dart';

class DiceCollectionListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionManager>(
      builder: (context, collectionManager, child) {
        List<Widget> listTiles = collectionManager.diceCollections
            .map((col) => DiceCollectionListTile(
                  diceCollection: col,
                ))
            .toList();
        return ListView(
          children: listTiles,
        );
      },
    );
  }
}
