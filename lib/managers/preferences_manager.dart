import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {

  static const _LIST_VIEW_PREFERENCE_KEY = 'list_view_preference';

  void setListViewPreference(bool isListView) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(_LIST_VIEW_PREFERENCE_KEY, isListView);
  }

  Future<bool> getListViewPreference() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_LIST_VIEW_PREFERENCE_KEY)) {
      return prefs.getBool(_LIST_VIEW_PREFERENCE_KEY);
    } else {
      setListViewPreference(true);
      return true;
    }
  }

}