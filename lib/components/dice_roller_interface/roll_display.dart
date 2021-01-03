import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/dice_engine/ast/nodes/die.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/utils.dart';

class RollDisplay extends StatelessWidget {
  int id;
  RollDisplay({@required this.id});

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------------------------------
    // variables
    // -------------------------------------------------------------------------------------------------

    var historyManager = Provider.of<HistoryManager>(context);
    var diceCollection = Provider.of<CollectionManager>(context).getCollection(id);
    var lastResult = historyManager.getLastResultOfID(id);
    var theme = Provider.of<ThemeManager>(context).theme;

    var currentTotalStyle = TextStyle(
      color: theme.rollerTotalColor,
      fontSize: 64,
    );

    // -------------------------------------------------------------------------------------------------
    // functions
    // -------------------------------------------------------------------------------------------------

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
      // strikethrough an overwritten Die
      if (die.isOverwritten) {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${die.values.first}',
                style: textStyle.copyWith(decoration: TextDecoration.lineThrough),
              ),
              TextSpan(
                text: '  ${die.value}',
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

    // -------------------------------------------------------------------------------------------------
    // return
    // -------------------------------------------------------------------------------------------------

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onLongPress: () {},
      onTap: () {
        diceCollection.roll(context: context);
      },
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: lastResult != null
              ? [
                  // the current result
                  SizedBox(
                    height: 80,
                    child: Text(
                      '${lastResult.total}',
                      style: TextStyle(color: theme.rollerTotalColor, fontSize: 64),
                    ),
                  ),
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
                    child: FaIcon(
                      FontAwesomeIcons.diceD20,
                      size: 80,
                      color: theme.genericPrimaryTextColor,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
