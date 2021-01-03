import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/dice_roller_interface/distribution_viewer.dart';
import 'package:rpg_dice/components/dice_roller_interface/info_widget.dart';
import 'package:rpg_dice/components/dice_roller_interface/roll_display.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
import 'package:rpg_dice/components/dice_roller_interface/roll_history.dart';
import 'package:rpg_dice/dice_engine/ast/nodes/die.dart';
import 'package:rpg_dice/dice_engine/ast/objects/result.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/popups/create_new_dice_collection_popup.dart';
import 'package:rpg_dice/utils.dart';

// ignore: must_be_immutable
class DiceRollerInterface extends StatefulWidget {
  int _diceCollectionId;

  DiceRollerInterface({int diceCollectionId}) {
    this._diceCollectionId = diceCollectionId;
  }

  @override
  _DiceRollerInterfaceState createState() => _DiceRollerInterfaceState();
}

// =================================================================================================
// STATE
// =================================================================================================

class _DiceRollerInterfaceState extends State<DiceRollerInterface> {
  // ATTRIBUTES
  var historyScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;
    var historyManager = Provider.of<HistoryManager>(context);
    var collectionManager = Provider.of<CollectionManager>(context);
    var diceCollection = collectionManager.getCollection(widget._diceCollectionId);
    var results = historyManager.getResultsOfID(widget._diceCollectionId);
    Result lastResult;
    if (results.isEmpty) {
      lastResult = null;
    } else {
      lastResult = results.first;
    }

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // the name and expression
              Card(
                elevation: 0,
                color: theme.genericCardColor,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: DiceCollectionInfo(
                    id: widget._diceCollectionId,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // the header that can be tapped to reroll
              Card(
                elevation: 0,
                color: theme.genericCardColor,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: RollDisplay(
                    id: widget._diceCollectionId,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // TODO a breakdown of the rolls?

              // the history
              Card(
                elevation: 0,
                color: theme.genericCardColor,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: RollHistory(widget._diceCollectionId),
                ),
              ),
              SizedBox(height: 10),

              // the dice counter
              Card(
                elevation: 0,
                color: theme.genericCardColor,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: DistributionViewer(
                    expression: diceCollection.expression,
                    numRepeats: 1000,
                    title: 'Distribution',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
