import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/objects/dice_result.dart';
import 'package:rpg_dice/utils.dart';

class DiceRollerPopup extends StatelessWidget {
  DiceCollection _diceCollection;

  DiceRollerPopup({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  void roll() {}

  @override
  Widget build(BuildContext context) {
    ScrollController historyScrollController = ScrollController();

    // TextStyles
    TextStyle nameAndExpressionStyle = TextStyle(
      fontSize: 22,
    );

    TextStyle currentTotalStyle = TextStyle(
      fontSize: 64,
    );

    TextStyle currentOutcomesStyle = TextStyle(
      fontSize: 22,
    );

    TextStyle historyLabelStyle = TextStyle(
      fontSize: 16,
    );

    TextStyle historyResultStyle = TextStyle(
      fontSize: 28,
    );

    DiceResult diceResult = DiceResult();

    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // the header that can be tapped to reroll
            InkWell(
              onTap: roll,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // the DiceCollection's name and dice
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(this._diceCollection.name ?? "DICE", style: nameAndExpressionStyle),
                      Text(this._diceCollection.expression, style: nameAndExpressionStyle),
                    ],
                  ),
                  SizedBox(height: 16),

                  // the current result
                  Text("${diceResult.total}", style: currentTotalStyle),
                  SizedBox(height: 4),

                  // the constituent rolls
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: intersperse(
                      diceResult.allOutcomes.map((outcome) => Text("$outcome", style: currentOutcomesStyle)).toList(),
                      () => SizedBox(width: 10),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // the history
            Text("History", style: historyLabelStyle),
            SizedBox(height: 4),
            ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Consumer<HistoryManager>(
                  builder: (context, historyManager, child) {
                    List<int> previousResults = List.generate(20, (i) => i + 1);
                    List<Widget> previousResultWidgets = previousResults.map((result) {
                      return Text("$result", style: historyResultStyle);
                    }).toList();
                    List<Widget> previousResultsSpaced = intersperse(previousResultWidgets, () => SizedBox(width: 5));

                    return Scrollbar(
                      isAlwaysShown: true,
                      controller: historyScrollController,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: historyScrollController,
                        child: Row(
                          children: previousResultsSpaced,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
