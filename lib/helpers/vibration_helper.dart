import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/settings_manager.dart';

class VibrationHelper {

  BuildContext context;

  VibrationHelper(this.context);

  void vibrate({int duration}) {
    var settingsManager = Provider.of<SettingsManager>(context);
    if (settingsManager.isVibrationOn) {
      // vibrate
    }
  }

}