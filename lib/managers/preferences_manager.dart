import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {

  // -------------------------------------------------------------------------------------------------
  // HomeScreen: does the user prefer a list view or a grid view?
  // -------------------------------------------------------------------------------------------------

  static const _LIST_VIEW_PREFERENCE_KEY = 'list_view_preference';

  void setListViewPreference(bool isListView) async {
    print('PreferencesManager setting $_LIST_VIEW_PREFERENCE_KEY to $isListView');
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

  // -------------------------------------------------------------------------------------------------
  // DistributionViewer: does the user prefer the graphical view or the list view?
  // -------------------------------------------------------------------------------------------------

  static const _DISTRIBUTION_VIEW_PREFERENCE_KEY = 'distribution_view_preference';

  void setDistributionViewPreference(bool isGraphView) async {
    print('PreferencesManager setting $_DISTRIBUTION_VIEW_PREFERENCE_KEY to $isGraphView');
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(_DISTRIBUTION_VIEW_PREFERENCE_KEY, isGraphView);
  }

  Future<bool> getDistributionViewPreference() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_DISTRIBUTION_VIEW_PREFERENCE_KEY)) {
      return prefs.getBool(_DISTRIBUTION_VIEW_PREFERENCE_KEY);
    } else {
      setListViewPreference(true);
      return true;
    }
  }

}