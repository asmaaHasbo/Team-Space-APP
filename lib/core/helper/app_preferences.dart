import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences _prefs;
  AppPreferences(this._prefs);

  static const _selectedSpaceIdKey = 'selected_space_id';

  Future<void> setSelectedSpaceId(String id) =>
      _prefs.setString(_selectedSpaceIdKey, id);

  String? getSelectedSpaceId() => _prefs.getString(_selectedSpaceIdKey);
}