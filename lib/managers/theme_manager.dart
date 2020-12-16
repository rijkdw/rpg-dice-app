import 'package:flutter/material.dart';
import 'package:rpg_dice/objects/app_theme.dart';
import 'package:rpg_dice/color_palette.dart' as ColorPalette;
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
      // drawer
      drawerHeaderColor: Colors.red,
      drawerHeaderTextColor: Colors.white,
      drawerBodyColor: Colors.white,
      drawerBodyTextColor: Colors.black,
      drawerBodyIconColor: Colors.red,
      // appbar
      appbarColor: Colors.red,
      appbarTextColor: Colors.white,
      // list
      listTileIconColor: Colors.red,
      listTileTitleTextColor: Colors.black,
      listTileSubtitleTextColor: ColorPalette.medGray,
      listViewBackgroundColor: Colors.white,
    ),
    ThemeSelection.DARK: MyAppTheme(
      // drawer
      drawerHeaderColor: ColorPalette.medGray,
      drawerHeaderTextColor: Colors.white,
      drawerBodyColor: ColorPalette.darkGray,
      drawerBodyTextColor: Colors.white,
      drawerBodyIconColor: Colors.white,
      // appbar
      appbarColor: ColorPalette.medGray,
      appbarTextColor: Colors.white,
      // list
      listTileIconColor: Colors.red,
      listTileTitleTextColor: Colors.white,
      listTileSubtitleTextColor: Colors.white70,
      listViewBackgroundColor: ColorPalette.darkGray,
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
