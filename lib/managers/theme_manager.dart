import 'package:flutter/material.dart';
import 'package:rpg_dice/enums/theme_selection.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';
import 'package:rpg_dice/color_palette.dart' as ColorPalette;
import 'package:rpg_dice/utils.dart';

class ThemeManager extends ChangeNotifier {
  // ATTRIBUTES

  // the map containing light mode and dark mode's colors
  Map<ThemeSelection, MyAppTheme> _themeMap = {
    ThemeSelection.LIGHT: MyAppTheme(
      // drawer
      drawerHeaderColor: Colors.red,
      drawerHeaderTextColor: Colors.white,
      drawerHeaderIconColor: Colors.white,
      drawerBodyColor: Colors.white,
      drawerBodyTextColor: Colors.black,
      drawerBodyIconColor: Colors.red,
      // appbar
      appbarColor: Colors.red,
      appbarTextColor: Colors.white,
      // list tile
      listTileIconColor: Colors.red,
      listTileTitleTextColor: Colors.black,
      listTileSubtitleTextColor: ColorPalette.medGray,
      // list view
      listViewBackgroundColor: Colors.white,
      listViewScrollBarColor: ColorPalette.white180,
      // dice roller popup
      rollerPopupBackgroundColor: Colors.white,
      rollerNameAndExpressionColor: ColorPalette.darkGray,
      rollerHistoryResultColor: Colors.black,
      rollerTotalColor: Colors.black,
      rollerHistoryLabelColor: ColorPalette.darkGray,
      rollerDiscardedColor: ColorPalette.gray160,
      // menu popup
      menuPopupListTileTextColor: Colors.black,
      menuPopupListTileIconColor: Colors.red,
      menuPopupBackgroundColor: Colors.white,
      menuPopupListTileDividerColor: ColorPalette.medGray,
      // new collection popup
      newFormBackgroundColor: Colors.white,
      newFormHintTextColor: ColorPalette.lightGray,
      newFormFieldTextColor: Colors.black,
      newFormFieldHeadingColor: Colors.black,
      newFormFieldButtonColor: Colors.red,
      newFormFieldButtonTextColor: Colors.white,
    ),
    ThemeSelection.DARK: MyAppTheme(
      // drawer
      drawerHeaderColor: ColorPalette.medGray,
      drawerHeaderTextColor: Colors.white,
      drawerHeaderIconColor: Colors.red,
      drawerBodyColor: ColorPalette.darkGray,
      drawerBodyTextColor: Colors.white,
      drawerBodyIconColor: Colors.red,
      // appbar
      appbarColor: ColorPalette.medGray,
      appbarTextColor: Colors.white,
      // list tile
      listTileIconColor: Colors.red,
      listTileTitleTextColor: Colors.white,
      listTileSubtitleTextColor: Colors.white70,
      // list view
      listViewBackgroundColor: ColorPalette.darkGray,
      listViewScrollBarColor: ColorPalette.lightGray,
      // dice roller popup
      rollerPopupBackgroundColor: ColorPalette.medGray,
      rollerNameAndExpressionColor: ColorPalette.white225,
      rollerHistoryLabelColor: ColorPalette.white180,
      rollerTotalColor: Colors.white,
      rollerHistoryResultColor: ColorPalette.white225,
      rollerDiscardedColor: ColorPalette.medGray,
      // menu popup
      menuPopupBackgroundColor: ColorPalette.medGray,
      menuPopupListTileDividerColor: ColorPalette.white180,
      menuPopupListTileIconColor: Colors.red,
      menuPopupListTileTextColor: Colors.white,
      // new collection popup
      newFormBackgroundColor: ColorPalette.medGray,
      newFormFieldTextColor: Colors.white,
      newFormHintTextColor: ColorPalette.white180,
      newFormFieldButtonColor: Colors.red,
      newFormFieldHeadingColor: Colors.white,
      newFormFieldButtonTextColor: Colors.white,
    ),
  };

  // the current selection between light mode and dark mode
  ThemeSelection _currentThemeSelection;

  // CONSTRUCTOR

  ThemeManager() {
    this._currentThemeSelection = ThemeSelection.LIGHT;
    // TODO make this a saved setting via SharedPreferences or something
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
