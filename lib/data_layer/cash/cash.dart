import 'package:shared_preferences/shared_preferences.dart';

class CachHelper {
  static late SharedPreferences sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    }
    if (value is int) {
      return await sharedPreferences.setInt(key, value);
    }
    if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    } else {
      return await sharedPreferences.setBool(key, value);
    }
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }

  // static Future<bool> putStringDate({String? key, String? data}) async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   return await sharedPreferences.setString(key!, data!);
  // }
  //
  // static Future<bool> putBoolDate({String? key, bool? data}) async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   return await sharedPreferences.setBool(key!, data!);
  // }
  //
  // static Future<bool> getBoolDate({String? key}) async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   return await sharedPreferences.getBool(key!)!;
  // }
  //
  // static String getData(String key) {
  //   return sharedPreferences.getString(key)!;
  // }

  static Future<bool> deleteData(String key) async {
    return await sharedPreferences.remove(key);
  }
}
