import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppCacheProvider {
  static const String _launchesKey = 'cached_launches';
  static const String _rocketsKey = 'cached_rockets';
  static const String _companyKey = 'cached_company';
  static const String _lastUpdateKey = 'last_update';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> cacheLaunches(List<dynamic> launches) async {
    await _prefs.setString(_launchesKey, jsonEncode(launches));
    await _updateLastUpdate();
  }

  Future<void> cacheRockets(List<dynamic> rockets) async {
    await _prefs.setString(_rocketsKey, jsonEncode(rockets));
    await _updateLastUpdate();
  }

  Future<void> cacheCompany(Map<String, dynamic> company) async {
    await _prefs.setString(_companyKey, jsonEncode(company));
    await _updateLastUpdate();
  }

  Future<List<dynamic>?> getCachedLaunches() async {
    final data = _prefs.getString(_launchesKey);
    if (data != null) {
      return jsonDecode(data) as List<dynamic>;
    }
    return null;
  }

  Future<List<dynamic>?> getCachedRockets() async {
    final data = _prefs.getString(_rocketsKey);
    if (data != null) {
      return jsonDecode(data) as List<dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getCachedCompany() async {
    final data = _prefs.getString(_companyKey);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<DateTime?> getLastUpdate() async {
    final timestamp = _prefs.getInt(_lastUpdateKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  Future<void> _updateLastUpdate() async {
    await _prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> shouldRefreshData() async {
    final lastUpdate = await getLastUpdate();
    if (lastUpdate == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastUpdate);
    // Refresh if data is older than 1 hour
    return difference.inHours >= 1;
  }

  Future<void> clearCache() async {
    await _prefs.remove(_launchesKey);
    await _prefs.remove(_rocketsKey);
    await _prefs.remove(_companyKey);
    await _prefs.remove(_lastUpdateKey);
  }
} 