import 'package:shared_preferences/shared_preferences.dart';

class SharePreference {

  static SharedPreferences? _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<String> getFavorites() {
    return _prefs?.getStringList('favorites') ?? [];
  }

  static Future<void> toggleFavorite(String stopName) async {
    final favs = getFavorites();
    if (favs.contains(stopName)) {
      favs.remove(stopName);
    } else {
      favs.add(stopName);
    }
    await _prefs?.setStringList('favorites', favs);
  }
}