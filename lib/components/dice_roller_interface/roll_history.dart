import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/utils.dart';

class RollHistory extends StatelessWidget {
  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------
  int id;

  // -------------------------------------------------------------------------------------------------
  // constructor
  // -------------------------------------------------------------------------------------------------
  RollHistory({@required this.id});

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------------------------------
    // variables
    // -------------------------------------------------------------------------------------------------

    var historyManager = Provider.of<HistoryManager>(context);

    var theme = Provider.of<ThemeManager>(context).theme;
    var headingStyle = TextStyle(
      color: theme.rollerCardHeadingColor,
      fontSize: 20,
    );
    var resultStyle = TextStyle(
      color: theme.rollerHistoryResultColor,
      fontSize: 36,
    );

    // -------------------------------------------------------------------------------------------------
    // return
    // -------------------------------------------------------------------------------------------------

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('History', style: headingStyle),
            Row(
              children: [
                historyManager.getResultsOfID(id).length > 0
                    ? Text('${historyManager.getResultsOfID(id).length}', style: headingStyle)
                    : Container(),
                SizedBox(width: 2),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete,
                      color: theme.rollerCardHeadingColor,
                    ),
                  ),
                  onTap: () {
                    historyManager.clearHistory(id);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ],
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
                List<String> previousResults =
                    Provider.of<HistoryManager>(context).getResultsOfID(id).map((result) => '${result.total}').toList();
                if (previousResults.isEmpty) {
                  previousResults = [''];
                }
                // make into Text widgets
                List<Widget> previousResultWidgets = previousResults.map((result) {
                  return Text(
                    result,
                    style: resultStyle,
                  );
                }).toList();
                // put space (SizedBoxes) between
                List<Widget> previousResultsSpaced = intersperse(
                  previousResultWidgets,
                  () => SizedBox(width: 15),
                );
                return Row(
                  children: previousResultsSpaced,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
