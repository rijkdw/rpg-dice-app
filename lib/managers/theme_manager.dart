import 'package:flutter/material.dart';
import 'package:rpg_dice/enums/theme_selection.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';
import 'package:rpg_dice/color_palette.dart' as ColorPalette;
import 'package:rpg_dice/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  // ATTRIBUTES

  // the map containing light mode and dark mode's colors
  Map<ThemeSelection, MyAppTheme> _themeMap = {
    ThemeSelection.LIGHT: MyAppTheme(
      // generic
      genericCanvasColor: Color.fromRGBO(240, 240, 240, 1),
      genericButtonTextColor: Colors.white,
      genericButtonColor: Colors.red,
      genericPrimaryTextColor: Colors.black,
      genericCardColor: Colors.white,
      // drawer
      drawerHeaderColor: Colors.red,
      drawerHeaderTextColor: Colors.white,
      drawerHeaderIconColor: Colors.white,
      drawerBodyColor: Colors.white,
      drawerBodyTextColor: Colors.black,
      drawerBodyIconColor: Colors.red,
      drawerDividerColor: ColorPalette.gray160,
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
      rollerCardHeadingColor: ColorPalette.darkGray,
      rollerDiscardedColor: ColorPalette.gray160,
      rollerReadyIconColor: Colors.red,
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
      // balance
      balanceHeadingColor: Colors.black,
      balanceBarColors: [Colors.red],
      balanceAxesTextColor: Colors.black,
      balanceCardColor: Color.fromRGBO(240, 240, 240, 1),
    ),
    ThemeSelection.DARK: MyAppTheme(
      // generic
      genericButtonColor: Colors.red,
      genericButtonTextColor: Colors.white,
      genericCanvasColor: ColorPalette.darkGray,
      genericPrimaryTextColor: Colors.white,
      genericCardColor: ColorPalette.medGray,
      // drawer
      drawerHeaderColor: ColorPalette.medGray,
      drawerHeaderTextColor: Colors.white,
      drawerHeaderIconColor: Colors.red,
      drawerBodyColor: ColorPalette.darkGray,
      drawerBodyTextColor: Colors.white,
      drawerBodyIconColor: Colors.red,
      drawerDividerColor: ColorPalette.gray160,
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
      rollerCardHeadingColor: ColorPalette.white180,
      rollerTotalColor: Colors.white,
      rollerHistoryResultColor: ColorPalette.white225,
      rollerDiscardedColor: ColorPalette.lightGray,
      rollerReadyIconColor: Colors.red,
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
      // balance checker
      balanceAxesTextColor: Colors.white,
      balanceBarColors: [Colors.red],
      balanceHeadingColor: Colors.white,
      balanceCardColor: ColorPalette.medGray,
    ),
  };

  // the current selection between light mode and dark mode
  ThemeSelection _currentThemeSelection = ThemeSelection.LIGHT;

  // CONSTRUCTOR

  ThemeManager() {
    _loadFromLocal();
  }

  // STORE / LOAD

  var _storageKey = 'theme_islight';

  void _storeToLocal() async {
    print('ThemeManager._storeToLocal() is starting.');
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(_storageKey, _currentThemeSelection == ThemeSelection.LIGHT);
    print('ThemeManager._storeToLocal() has finished.');
  }

  void _loadFromLocal() async {
    print('ThemeManager._loadFromLocal() is starting.');
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_storageKey)) {
      _currentThemeSelection = prefs.getBool(_storageKey) ? ThemeSelection.LIGHT : ThemeSelection.DARK;
    } else {
      _currentThemeSelection = ThemeSelection.LIGHT;
    }
    print('ThemeManager._loadFromLocal() has finished.');
    notifyListeners();
  }

  // FUNCTIONS

  void swapSelection() {
    if (this._currentThemeSelection == ThemeSelection.LIGHT)
      this._currentThemeSelection = ThemeSelection.DARK;
    else
      this._currentThemeSelection = ThemeSelection.LIGHT;
    _storeToLocal();
    notifyListeners();
  }

  // GETTERS

  MyAppTheme get theme => this._themeMap[this._currentThemeSelection];

  String get currentThemeAsString {
    return toSentenceCase(this._currentThemeSelection.toString().replaceAll("ThemeSelection.", ""));
  }
}
