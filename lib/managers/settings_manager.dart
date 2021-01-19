import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager extends ChangeNotifier {

  Map<String, dynamic> _settings = {
    _IS_VIBRATION_ON_KEY: true,
  };

  // -------------------------------------------------------------------------------------------------
  // keys
  // -------------------------------------------------------------------------------------------------

  static const _SETTINGS_MAP_KEY = 'settings';

  // individual settings' keys
  static const _IS_VIBRATION_ON_KEY = 'isVibrationOn';

  // default settings
  // var _defaultSettings =

  SettingsManager() {
    // _settings = _defaultSettings;
    _loadFromLocal();
  }

  // -------------------------------------------------------------------------------------------------
  // get settings
  // -------------------------------------------------------------------------------------------------

  bool _getBool(String key) {
    if (!_settings.keys.contains(key)) throw Exception('No such key: $key');
    return _settings[key];
  }

  bool get isVibrationOn => _getBool(_IS_VIBRATION_ON_KEY);

  // -------------------------------------------------------------------------------------------------
  // change settings
  // -------------------------------------------------------------------------------------------------

  void _genericSetSequence() {
    notifyListeners();
  }

  void _setBool(String key, bool newVal) {
    _settings[key] = newVal;
    _genericSetSequence();
  }

  void _invertBool(String key) {
    _settings[key] = !_settings[key];
    _genericSetSequence();
  }

  set isVibrationOn(bool newVal) => _setBool(_IS_VIBRATION_ON_KEY, newVal);
  void invertVibration() => _invertBool(_IS_VIBRATION_ON_KEY);

  // -------------------------------------------------------------------------------------------------
  // store / load
  // -------------------------------------------------------------------------------------------------

  void _loadFromLocal() async {
    var prefs = await SharedPreferences.getInstance();
    // TODO
    notifyListeners();
  }

}