import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
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
  Result result;
  var historyScrollController = ScrollController();

  @override
  void initState() {
    roll();
    super.initState();
  }

  void roll() {
    setState(() {
      result = Roller.roll(widget._diceCollection.expression);
      Provider.of<HistoryManager>(context, listen: false).addToHistory(widget._diceCollection.id, result);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;

    // TextStyles
    var nameAndExpressionStyle = TextStyle(
      fontSize: 22,
      color: theme.rollerNameAndExpressionColor,
    );

    var currentTotalStyle = TextStyle(
      color: theme.rollerTotalColor,
      fontSize: 64,
    );

    var historyLabelStyle = TextStyle(
      color: theme.rollerHistoryLabelColor,
      fontSize: 16,
    );

    var historyResultStyle = TextStyle(
      color: theme.rollerHistoryResultColor,
      fontSize: 36,
    );

    Widget die2widget(Die die) {
      var text = '${die.value}';
      if (die.exploded) text += '!';

      var baseTextStyle = TextStyle(fontSize: 22, color: theme.rollerTotalColor);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // the header that can be tapped to reroll
        InkWell(
          onTap: roll,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // the DiceCollection's name and dice
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(this.widget._diceCollection.name ?? "Unnamed hand", style: nameAndExpressionStyle),
                    Text(this.widget._diceCollection.expression, style: nameAndExpressionStyle),
                  ],
                ),
                SizedBox(height: 30),

                // the current result
                Text("${result.total}", style: currentTotalStyle),
                SizedBox(height: 12),

                // the constituent rolls
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: intersperse(
                    result.die.map(die2widget).toList(),
                    () => SizedBox(width: 10),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),

        // TODO breakdown

        // the history
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("History", style: historyLabelStyle),
                  InkWell(
                    child: Icon(
                      Icons.delete,
                      color: theme.rollerHistoryLabelColor,
                    ),
                    onTap: () {
                      Provider.of<HistoryManager>(context, listen: false).clearHistory(widget._diceCollection.id);
                    },
                    splashColor: Colors.transparent,
                  ),
                ],
              ),
              SizedBox(height: 4),
              ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Consumer<HistoryManager>(
                    builder: (context, historyManager, child) {
                      // get previous results
                      List<int> previousResults = Provider.of<HistoryManager>(context)
                          .getResultsOfID(widget._diceCollection.id)
                          .map((result) => result.total)
                          .toList();
                      // make into Text widgets
                      List<Widget> previousResultWidgets = previousResults.map((result) {
                        return Text(
                          "$result",
                          style: historyResultStyle,
                        );
                      }).toList();
                      // put space (SizedBoxes) between
                      List<Widget> previousResultsSpaced = intersperse(
                        previousResultWidgets,
                        () => SizedBox(width: 25),
                      );
                      return Row(
                        children: previousResultsSpaced,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
