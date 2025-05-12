import 'package:shared_preferences/shared_preferences.dart';

/// Utility class to manage simple user session data using SharedPreferences.
/// Used to store and retrieve the user's name locally.
class UserSessionUtil {
  static const String _keyUserName = 'user_name'; // Storage key for username

  /// Saves the user's name in local storage.
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  /// Retrieves the user's name from local storage.
  /// Returns null if no user is saved.
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  /// Clears the user's session by removing the stored name.
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserName);
  }
}
