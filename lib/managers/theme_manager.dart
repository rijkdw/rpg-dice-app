import 'package:flutter/material.dart';
import 'package:rpg_dice/objects/app_theme.dart';
import 'package:rpg_dice/utils.dart';

enum ThemeSelection {
  LIGHT,
  DARK,
}

class ThemeManager extends ChangeNotifier {
  // ATTRIBUTES

  // the map containing light mode and dark mode's colors
  Map<ThemeSelection, MyAppTheme> _themeMap = {
    ThemeSelection.LIGHT: MyAppTheme(
      drawerHeaderColor: Colors.red,
    ),
    ThemeSelection.DARK: MyAppTheme(
      drawerHeaderColor: Colors.black54,
    ),
  };

  // the current selection between light mode and dark mode
  ThemeSelection _currentThemeSelection;

  // CONSTRUCTOR

  ThemeManager() {
    this._currentThemeSelection = ThemeSelection.LIGHT;
  }

  // FUNCTIONS

  void swapSelection() {
    if (this._currentThemeSelection == ThemeSelection.LIGHT)
      this._currentThemeSelection = ThemeSelection.DARK;
    else
      this._currentThemeSelection = ThemeSelection.LIGHT;
    notifyListeners();
  }

  // GETTERS

  MyAppTheme get theme => this._themeMap[this._currentThemeSelection];

  String get currentThemeAsString {
    return toSentenceCase(this._currentThemeSelection.toString().replaceAll("ThemeSelection.", ""));
  }
}
