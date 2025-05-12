import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppCacheProvider {
  static const String _launchesKey = 'cached_launches';
  static const String _rocketsKey = 'cached_rockets';
  static const String _companyKey = 'cached_company';
  static const String _lastUpdateKey = 'last_update';
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);

  SharedPreferences? _prefs;
  bool _isInitialized = false;
  bool _isInitializing = false;
  int _initRetryCount = 0;

  Future<void> init() async {
    if (_isInitialized) return;
    if (_isInitializing) return;

    try {
      _isInitializing = true;
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      _initRetryCount = 0; // Reset retry count on success
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
      _isInitialized = false;

      // Implement retry logic
      if (_initRetryCount < _maxRetries) {
        _initRetryCount++;
        print(
            'Retrying initialization (attempt $_initRetryCount of $_maxRetries)...');
        await Future.delayed(_retryDelay);
        await init(); // Retry initialization
      } else {
        print(
            'Failed to initialize SharedPreferences after $_maxRetries attempts');
        rethrow;
      }
    } finally {
      _isInitializing = false;
    }
  }

  Future<bool> _ensureInitialized() async {
    if (!_isInitialized) {
      try {
        await init();
      } catch (e) {
        print('Failed to initialize cache: $e');
        return false;
      }
    }
    return _isInitialized;
  }

  Future<String?> getLastUpdate() async {
    try {
      if (!await _ensureInitialized()) return null;
      return _prefs?.getString(_lastUpdateKey);
    } catch (e) {
      print('Error getting last update time: $e');
      return null;
    }
  }

  Future<void> cacheLaunches(List launches) async {
    try {
      if (!await _ensureInitialized()) return;
      await _prefs?.setString(_launchesKey, jsonEncode(launches));
      await _updateLastUpdateTime();
    } catch (e) {
      print('Error caching launches: $e');
      rethrow;
    }
  }

  Future<List?> getCachedLaunches() async {
    try {
      if (!await _ensureInitialized()) return null;
      final String? data = _prefs?.getString(_launchesKey);
      return data != null ? jsonDecode(data) as List : null;
    } catch (e) {
      print('Error getting cached launches: $e');
      return null;
    }
  }

  Future<void> cacheRockets(List rockets) async {
    try {
      if (!await _ensureInitialized()) return;
      await _prefs?.setString(_rocketsKey, jsonEncode(rockets));
      await _updateLastUpdateTime();
    } catch (e) {
      print('Error caching rockets: $e');
      rethrow;
    }
  }

  Future<List?> getCachedRockets() async {
    try {
      if (!await _ensureInitialized()) return null;
      final String? data = _prefs?.getString(_rocketsKey);
      return data != null ? jsonDecode(data) as List : null;
    } catch (e) {
      print('Error getting cached rockets: $e');
      return null;
    }
  }

  Future<void> cacheCompany(Map<String, dynamic> company) async {
    try {
      if (!await _ensureInitialized()) return;
      await _prefs?.setString(_companyKey, jsonEncode(company));
      await _updateLastUpdateTime();
    } catch (e) {
      print('Error caching company data: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCachedCompany() async {
    try {
      if (!await _ensureInitialized()) return null;
      final String? data = _prefs?.getString(_companyKey);
      return data != null ? jsonDecode(data) as Map<String, dynamic> : null;
    } catch (e) {
      print('Error getting cached company data: $e');
      return null;
    }
  }

  Future<void> _updateLastUpdateTime() async {
    try {
      if (!await _ensureInitialized()) return;
      await _prefs?.setString(_lastUpdateKey, DateTime.now().toIso8601String());
    } catch (e) {
      print('Error updating last update time: $e');
      rethrow;
    }
  }

  Future<bool> shouldRefreshData() async {
    try {
      if (!await _ensureInitialized()) return true;

      final String? lastUpdate = _prefs?.getString(_lastUpdateKey);
      if (lastUpdate == null) return true;

      final lastUpdateTime = DateTime.parse(lastUpdate);
      final now = DateTime.now();
      return now.difference(lastUpdateTime).inHours >= 24;
    } catch (e) {
      print('Error checking if data should refresh: $e');
      return true; // Default to refreshing on error
    }
  }

  // Method to clear all cached data
  Future<void> clearCache() async {
    try {
      if (!await _ensureInitialized()) return;
      await _prefs?.clear();
      _isInitialized = false;
    } catch (e) {
      print('Error clearing cache: $e');
      rethrow;
    }
  }
}
