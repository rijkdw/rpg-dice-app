import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/settings_form.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/constants.dart' as constants;

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------------------------------
    // variables
    // -------------------------------------------------------------------------------------------------
    var theme = Provider.of<ThemeManager>(context).theme;

    // -------------------------------------------------------------------------------------------------
    // return
    // -------------------------------------------------------------------------------------------------
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: theme.appbarColor,
        elevation: constants.APPBAR_ELEVATION,
      ),
      backgroundColor: theme.genericCanvasColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SettingsForm(),
      ),
    );
  }
}
