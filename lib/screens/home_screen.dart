import 'package:flutter/material.dart';
import 'package:rpg_dice/components/dice_collection_listview.dart';
import 'package:rpg_dice/components/my_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RPG Dice"),
        elevation: 0,
      ),
      drawer: MyDrawer(),
      body: DiceCollectionListView(),
    );
  }

}