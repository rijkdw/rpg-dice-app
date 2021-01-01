import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/dice_roller_interface.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

// ignore: must_be_immutable
class DiceRollerScreen extends StatelessWidget {
  DiceCollection _diceCollection;

  DiceRollerScreen({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  @override
  Widget build(BuildContext context) {

    var theme = Provider.of<ThemeManager>(context).theme;

    return Scaffold(
      backgroundColor: theme.genericCanvasColor,
      appBar: AppBar(
        backgroundColor: theme.appbarColor,
        elevation: 0,
        // title: Text(
        //   _diceCollection.name,
        // ),
      ),
      body: DiceRollerInterface(
        diceCollection: _diceCollection,
      ),
    );
  }

}