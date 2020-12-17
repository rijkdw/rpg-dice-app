import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/add_new_dice_collection_FAB.dart';
import 'package:rpg_dice/components/dice_collection_listview.dart';
import 'package:rpg_dice/components/my_drawer.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyAppTheme theme = Provider.of<ThemeManager>(context).theme;
    CollectionManager collectionManager = Provider.of<CollectionManager>(context);

    void debugFunction() async {
      DiceCollection dummyCollection = DiceCollection(
        name: "DUMMY",
        expression: "1d20",
        id: 10,
      );
      collectionManager.addToCollections(dummyCollection);
      await Future.delayed(Duration(seconds: 3));
      collectionManager.deleteCollection(10);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RPG Dice",
          style: TextStyle(color: theme.appbarTextColor),
        ),
        elevation: 0,
        backgroundColor: theme.appbarColor,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.bug_report),
        //     onPressed: debugFunction,
        //   ),
        // ],
      ),
      drawer: MyDrawer(),
      backgroundColor: theme.listViewBackgroundColor,
      body: Container(
        padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
        child: DiceCollectionListView(),
      ),
      floatingActionButton: AddNewDiceCollectionFAB(),
    );
  }
}
