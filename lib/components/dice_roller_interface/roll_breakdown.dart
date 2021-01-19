import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';

class RollBreakdown extends StatelessWidget {
  int id;
  RollBreakdown({@required this.id});

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------------------------------
    // variables
    // -------------------------------------------------------------------------------------------------

    var theme = Provider.of<ThemeManager>(context).theme;
    var historyManager = Provider.of<HistoryManager>(context);
    var lastResult = historyManager.getLastResultOfID(id);

    // -------------------------------------------------------------------------------------------------
    // return
    // -------------------------------------------------------------------------------------------------

    return Container(
      width: double.infinity,
      child: lastResult == null ? Container() : Container(),
    );
  }
}
