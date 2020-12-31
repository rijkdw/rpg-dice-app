import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/utils.dart';

class RollHistory extends StatelessWidget {
  // attributes
  int id;

  // constructor
  RollHistory(this.id);

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;

    var historyLabelStyle = TextStyle(
      color: theme.rollerHistoryLabelColor,
      fontSize: 16,
    );

    var historyResultStyle = TextStyle(
      color: theme.rollerHistoryResultColor,
      fontSize: 36,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('History', style: historyLabelStyle),
            InkWell(
              child: Icon(
                Icons.delete,
                color: theme.rollerHistoryLabelColor,
              ),
              onTap: () {
                Provider.of<HistoryManager>(context, listen: false).clearHistory(id);
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
                List<String> previousResults = Provider.of<HistoryManager>(context)
                    .getResultsOfID(id)
                    .map((result) => '${result.total}')
                    .toList();
                if (previousResults.isEmpty) {
                  previousResults = [''];
                }
                // make into Text widgets
                List<Widget> previousResultWidgets = previousResults.map((result) {
                  return Text(
                    result,
                    style: historyResultStyle,
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
