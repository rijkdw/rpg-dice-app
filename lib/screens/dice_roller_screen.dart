import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/dice_roller_interface/dice_roller_interface.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

// ignore: must_be_immutable
class DiceRollerScreen extends StatefulWidget {
  DiceCollection _diceCollection;

  DiceRollerScreen({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  @override
  _DiceRollerScreenState createState() => _DiceRollerScreenState();
}

class _DiceRollerScreenState extends State<DiceRollerScreen> {
  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------
  var pageViewController = ScrollController();
  var showingNavButton = false;

  @override
  void initState() {
    pageViewController.addListener(() {
      var topThreshold = 50;
      if (pageViewController.offset > topThreshold) {
        setState(() {
          showingNavButton = true;
        });
      } else {
        setState(() {
          showingNavButton = false;
        });
      }
    });
    super.initState();
  }

  // -------------------------------------------------------------------------------------------------
  // build
  // -------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;
    return Scaffold(
      backgroundColor: theme.genericCanvasColor,
      floatingActionButton: showingNavButton
          ? FloatingActionButton(
              onPressed: () {
                pageViewController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.decelerate);
              },
              child: Icon(Icons.arrow_upward_rounded),
            )
          : null,
      appBar: AppBar(
        backgroundColor: theme.appbarColor,
      ),
      body: DiceRollerInterface(
        diceCollectionId: widget._diceCollection.id,
        pageViewController: pageViewController,
      ),
    );
  }
}
