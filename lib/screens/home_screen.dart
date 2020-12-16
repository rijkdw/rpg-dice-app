import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/add_new_dice_collection_FAB.dart';
import 'package:rpg_dice/components/dice_collection_listview.dart';
import 'package:rpg_dice/components/my_drawer.dart';
import 'package:rpg_dice/managers/theme_manager.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RPG Dice",
          style: TextStyle(color: Provider.of<ThemeManager>(context).theme.appbarTextColor),
        ),
        elevation: 0,
        backgroundColor: Provider.of<ThemeManager>(context).theme.appbarColor,
      ),
      drawer: MyDrawer(),
      body: DiceCollectionListView(),
      floatingActionButton: AddNewDiceCollectionFAB(),
    );
  }
}
