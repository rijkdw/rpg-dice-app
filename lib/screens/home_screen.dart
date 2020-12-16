import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/add_new_dice_collection_FAB.dart';
import 'package:rpg_dice/components/dice_collection_listview.dart';
import 'package:rpg_dice/components/my_drawer.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MyAppTheme theme = Provider.of<ThemeManager>(context).theme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RPG Dice",
          style: TextStyle(color: theme.appbarTextColor),
        ),
        elevation: 0,
        backgroundColor: theme.appbarColor,
      ),
      drawer: MyDrawer(),
      backgroundColor: theme.listViewBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: DiceCollectionListView(),
      ),
      floatingActionButton: AddNewDiceCollectionFAB(),
    );
  }
}
