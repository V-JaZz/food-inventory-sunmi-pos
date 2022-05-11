import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static const String keyLoginData = "loginData";
  static const String keyLoginToken = "loginToken";
  static const String keyEmail = "email";
  static const String keyRestaurantId = "restaurantId";
  static const String dataList = 'dataList';
  static Future<bool> setData(String key, dynamic value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (value is String) {
      return pref.setString(key, value);
    } else if (value is bool) {
      return pref.setBool(key, value);
    } else if (value is double) {
      return pref.setDouble(key, value);
    } else if (value is int) {
      return pref.setInt(key, value);
    } else if (value is List<String>) {
      return pref.setStringList(key, value);
    } else {
      return false;
    }
  }

  static Future<dynamic>? getData(String key, dynamic defaultVal) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (defaultVal is String) {
      return pref.getString(key) ?? defaultVal;
    } else if (defaultVal is int) {
      return pref.getInt(key) ?? defaultVal;
    } else if (defaultVal is bool) {
      return pref.getBool(key) ?? defaultVal;
    } else if (defaultVal is double) {
      return pref.getDouble(key) ?? defaultVal;
    } else if (defaultVal is List<String>) {
      return pref.getStringList(key) ?? defaultVal;
    } else {
      return null;
    }
  }

  static Future<dynamic> clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }
}
