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
  var showingNavButton = true;
  
  @override
  void initState() {
    pageViewController.addListener(() {
      var topThreshold = 50;
      print(pageViewController.offset);
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
  // widgets
  // -------------------------------------------------------------------------------------------------

  var backToTopFAB = FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.arrow_upward_rounded),
  );

  @override
  Widget build(BuildContext context) {

    var theme = Provider.of<ThemeManager>(context).theme;

    return Scaffold(
      backgroundColor: theme.genericCanvasColor,
      floatingActionButton: showingNavButton ? backToTopFAB : null,
      appBar: AppBar(
        backgroundColor: theme.appbarColor,
        // title: Text(
        //   // '${_diceCollection.name} (${_diceCollection.expression})',
        //   'Roller',
        // ),
      ),
      body: DiceRollerInterface(
        diceCollectionId: widget._diceCollection.id,
        pageViewController: pageViewController,
      ),
    );
  }
}