import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/dice_roller_interface/dice_counter.dart';
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
  DiceCollection _diceCollection;

  DiceRollerInterface({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
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
    // roll();
  }

  void roll() {
    widget._diceCollection.roll(context: context);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;
    var historyManager = Provider.of<HistoryManager>(context);
    var results = historyManager.getResultsOfID(widget._diceCollection.id);
    Result lastResult;
    if (results.isEmpty) {
      lastResult = null;
    } else {
      lastResult = results.first;
    }

    // TextStyles
    var nameAndExpressionStyle = TextStyle(
      fontSize: 18,
      color: theme.rollerNameAndExpressionColor,
    );

    var currentTotalStyle = TextStyle(
      color: theme.rollerTotalColor,
      fontSize: 64,
    );

    var labelStyle = TextStyle(
      color: theme.rollerHistoryLabelColor,
      fontSize: 20,
    );

    Widget die2widget(Die die, {TextStyle baseTextStyle}) {
      if (baseTextStyle == null) {
        baseTextStyle = TextStyle(fontSize: 22, color: theme.rollerTotalColor);
      }
      var text = '${die.value}';
      if (die.exploded) text += '!';
      var textStyle = baseTextStyle.copyWith();
      // bold a critical or a critical fail
      if (die.isCrit || die.isFail) textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
      // gray out a discarded Die
      if (die.isDiscarded) textStyle = textStyle.copyWith(color: theme.rollerDiscardedColor);
      if (die.isOverwritten) {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${die.values.first}',
                style: baseTextStyle,
              ),
              WidgetSpan(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.arrow_right_alt_rounded),
                ),
              ),
              TextSpan(
                text: '${die.value}',
                style: textStyle,
              ),
            ],
          ),
        );
      }
      return Text(
        text,
        style: textStyle,
      );
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Info', style: labelStyle),
                            InkWell(
                              child: Icon(
                                FontAwesomeIcons.wrench,
                                size: 20,
                                color: theme.rollerHistoryLabelColor,
                              ),
                              onTap: () {
                                // open the other dialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CreateNewDiceCollectionPopup(
                                      diceCollection: widget._diceCollection,
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.transparent,
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${widget._diceCollection.name}', style: nameAndExpressionStyle),
                            Text('${widget._diceCollection.expression}', style: nameAndExpressionStyle),
                          ],
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 10),

              // the header that can be tapped to reroll
              Card(
                elevation: 0,
                color: theme.genericCardColor,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onLongPress: () {},
                    onTap: () {
                      setState(() {
                        roll();
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: lastResult != null
                            ? [
                                // the current result
                                SizedBox(height: 80, child: Text('${lastResult.total}', style: currentTotalStyle)),
                                // SizedBox(height: 12),

                                // the constituent rolls
                                SizedBox(
                                  height: 20,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: intersperse(
                                      lastResult.die.map(die2widget).toList(),
                                      () => SizedBox(width: 10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                              ]
                            : [
                                Container(
                                  height: 112,
                                  alignment: Alignment.center,
                                  child: FaIcon(FontAwesomeIcons.diceD20, size: 80),
                                ),
                              ],
                      ),
                    ),
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
                  child: RollHistory(widget._diceCollection.id),
                ),
              ),
              SizedBox(height: 10),

              // the dice counter
              Card(
                elevation: 0,
                color: theme.genericCardColor,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: DiceCounter(
                    expression: widget._diceCollection.expression,
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
