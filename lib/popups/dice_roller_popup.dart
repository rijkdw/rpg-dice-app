import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/objects/dice_result.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';
import 'package:rpg_dice/utils.dart';

class DiceRollerPopup extends StatelessWidget {
  DiceCollection _diceCollection;

  DiceRollerPopup({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  void roll() {}

  @override
  Widget build(BuildContext context) {

    MyAppTheme theme = Provider.of<ThemeManager>(context).theme;

    ScrollController historyScrollController = ScrollController();

    // TextStyles
    TextStyle nameAndExpressionStyle = TextStyle(
      fontSize: 22,
      color: theme.rollerPopupNameAndExpressionColor,
    );

    TextStyle currentTotalStyle = TextStyle(
      color: theme.rollerPopupTotalColor,
      fontSize: 64,
    );

    TextStyle currentOutcomesStyle = TextStyle(
      color: Colors.green,
      fontSize: 22,
    );

    TextStyle historyLabelStyle = TextStyle(
      color: theme.rollerPopupHistoryLabelColor,
      fontSize: 16,
    );

    TextStyle historyResultStyle = TextStyle(
      color: theme.rollerPopupHistoryResultColor,
      fontSize: 28,
    );

    DiceResult diceResult = DiceResult();

    return Dialog(
      elevation: 0,
      backgroundColor: theme.rollerPopupBackgroundColor,
      child: Column(
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
                      Text(this._diceCollection.name ?? "Unnamed hand", style: nameAndExpressionStyle),
                      Text(this._diceCollection.expression, style: nameAndExpressionStyle),
                    ],
                  ),
                  SizedBox(height: 30),

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
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // the history
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                        List<Widget> previousResultsSpaced =
                            intersperse(previousResultWidgets, () => SizedBox(width: 10));

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
        ],
      ),
    );
  }
}
