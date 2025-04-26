import 'package:shared_preferences/shared_preferences.dart';

class UserSessionUtil {
  static const String _keyUserName = 'user_name';

  // Salva o nome do usuário na sessão
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  // Recupera o nome do usuário da sessão
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  // Limpa a sessão do usuário
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserName);
  }
}
