import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/dice_roller_interface/dice_roller_interface.dart';
import 'package:rpg_dice/components/no_glow_scroll_behavior.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/objects/dice_result.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';
import 'package:rpg_dice/utils.dart';

class DiceRollerPopup extends StatelessWidget {


  void roll() {}

  @override
  Widget build(BuildContext context) {

    MyAppTheme theme = Provider.of<ThemeManager>(context).theme;

    return Dialog(
      elevation: 0,
      backgroundColor: theme.rollerPopupBackgroundColor,
      child: DiceRollerInterface()
    );
  }
}
