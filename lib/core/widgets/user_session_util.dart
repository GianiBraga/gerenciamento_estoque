import 'package:shared_preferences/shared_preferences.dart';

/// Utility class to manage simple user session data using SharedPreferences.
/// Used to store and retrieve the user's name and role locally.
class UserSessionUtil {
  static const String _keyUserName = 'user_name'; // Storage key for username
  static const String _keyUserRole = 'user_role'; // Storage key for user role

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

  /// Saves the user's role ('admin' or 'user') in local storage.
  static Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserRole, role);
  }

  /// Retrieves the user's role from local storage.
  /// Returns null if no role is saved.
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole);
  }

  /// Clears the user's session by removing the stored name and role.
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserRole);
  }
}
