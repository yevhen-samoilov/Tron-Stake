import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DataBaseService {
  static read(String key) async {
    if (!await check(key)) return '';
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)!);
  }

  static Future<bool> check(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final bool check = prefs.containsKey(key);
    return check;
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<bool> getPremiumStatus() async {
    try {
      final isPremium = await DataBaseService.read('isPremium');
      return isPremium ?? false;
    } catch (e) {
      return false;
    }
  }
}
