import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/dice_counter.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
import 'package:rpg_dice/components/roll_history.dart';
import 'package:rpg_dice/dice_engine/ast/nodes/die.dart';
import 'package:rpg_dice/dice_engine/ast/objects/result.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
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
    roll();
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
      fontSize: 22,
      color: theme.rollerNameAndExpressionColor,
    );

    var currentTotalStyle = TextStyle(
      color: theme.rollerTotalColor,
      fontSize: 64,
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
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // the header that can be tapped to reroll
              InkWell(
                onTap: () {
                  setState(() {
                    roll();
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // the DiceCollection's name and dice
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(this.widget._diceCollection.name ?? 'Unnamed hand', style: nameAndExpressionStyle),
                        Text(this.widget._diceCollection.expression, style: nameAndExpressionStyle),
                      ],
                    ),
                    SizedBox(height: 30),

                    // the current result
                    SizedBox(
                      height: 80,
                      child: lastResult != null
                          ? Text('${lastResult.total}', style: currentTotalStyle)
                          : FaIcon(FontAwesomeIcons.diceD20, size: 80),
                    ),
                    SizedBox(height: 12),

                    // the constituent rolls
                    SizedBox(
                      height: 20,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: lastResult != null
                            ? intersperse(
                                lastResult.die.map(die2widget).toList(),
                                () => SizedBox(width: 10),
                              )
                            : [],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // TODO breakdown

              // the history
              RollHistory(widget._diceCollection.id),
              SizedBox(height: 30),

              // the dice counter
              DiceCounter(
                expression: widget._diceCollection.expression,
                numRepeats: 1000,
                title: 'Distribution',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
