import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/dice_roller_interface/distribution_viewer.dart';
import 'package:rpg_dice/components/dice_roller_interface/info_widget.dart';
import 'package:rpg_dice/components/dice_roller_interface/interface_card.dart';
import 'package:rpg_dice/components/dice_roller_interface/roll_display.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
import 'package:rpg_dice/components/dice_roller_interface/roll_history.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/utils.dart';

// ignore: must_be_immutable
class DiceRollerInterface extends StatefulWidget {
  int _diceCollectionId;
  ScrollController _pageViewController;

  DiceRollerInterface({int diceCollectionId, @required ScrollController pageViewController}) {
    this._diceCollectionId = diceCollectionId;
    this._pageViewController = pageViewController;
  }

  @override
  _DiceRollerInterfaceState createState() => _DiceRollerInterfaceState();
}

// =================================================================================================
// STATE
// =================================================================================================

class _DiceRollerInterfaceState extends State<DiceRollerInterface> {
  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------
  var historyScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------------------------------
    // variables
    // -------------------------------------------------------------------------------------------------

    var theme = Provider.of<ThemeManager>(context).theme;
    var collectionManager = Provider.of<CollectionManager>(context);
    var diceCollection = collectionManager.getCollection(widget._diceCollectionId);

    // -------------------------------------------------------------------------------------------------
    // cards
    // -------------------------------------------------------------------------------------------------

    var nameAndExpressionCard = Card(
      color: theme.genericCardColor,
      child: Container(
        padding: EdgeInsets.all(10),
        child: DiceCollectionInfo(
          id: widget._diceCollectionId,
        ),
      ),
    );

    var rollCard = Card(
      color: theme.genericCardColor,
      child: Container(
        padding: EdgeInsets.all(10),
        child: RollDisplay(
          id: widget._diceCollectionId,
        ),
      ),
    );

    var historyCard = Card(
      color: theme.genericCardColor,
      child: Container(
        padding: EdgeInsets.all(10),
        child: RollHistory(widget._diceCollectionId),
      ),
    );

    var historyCard2 = InterfaceCard(
      child: RollHistory(widget._diceCollectionId),
      title: 'History 2',
      expandable: true,
    );

    var distributionCard = Card(
      color: theme.genericCardColor,
      child: Container(
        padding: EdgeInsets.all(10),
        child: DistributionViewer(
          diceCollection: (diceCollection ?? DiceCollection.dummy()),
          numRepeats: 10000,
          pageViewController: widget._pageViewController,
        ),
      ),
    );

    // TODO a breakdown of the rolls?

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        controller: widget._pageViewController,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: intersperse([
              nameAndExpressionCard,
              rollCard,
              historyCard,
              distributionCard,
              SizedBox(height: 60),
            ], () => SizedBox(height: 10)),
          ),
        ),
      ),
    );
  }
}
