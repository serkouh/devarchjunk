import 'dart:convert';

import 'package:actitrack/src/config/constants/constants.dart';
import 'package:actitrack/src/models/user.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> get _instance async {
    _prefsInstance ??= await SharedPreferences.getInstance();
    return _prefsInstance!;
  }

  static Future<bool> clearAllData() async {
    bool? isCleared = await _prefsInstance!.clear();
    return isCleared;
  }

  /// call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static Future<bool> checkAppFirstLaunchState(
      {bool saveInPrefs = false}) async {
    final prefs = await _instance;
    bool isAppFirstLaunch = false;
    final launchState = prefs.getBool(kFirstLaunchPrefsKey);
    if (launchState != null && launchState == true) {
      isAppFirstLaunch = false;
    } else {
      try {
        if (saveInPrefs) {
          await prefs.setBool(kFirstLaunchPrefsKey, true);
        }
        isAppFirstLaunch = true;
      } catch (e) {
        MyLogger.error(e.toString());
      }
    }
    return isAppFirstLaunch;
  }

  static String? getPassCode() {
    final passcode = _prefsInstance!.getString(kPassCodePrefsKey) ?? '';
    if (passcode.isNotEmpty) {
      return passcode;
    }
    return null;
  }

  static Future<bool> setPassCode(String passcode) async {
    final prefs = await _instance;
    return prefs.setString(kPassCodePrefsKey, passcode);
  }

  static String? getUserAccessToken() {
    final accessToken =
        _prefsInstance!.getString(kAppUserAccessTokenPrefsKey) ?? '';
    if (accessToken.isNotEmpty) {
      return accessToken;
    }
    return null;
  }

  /// saves the APP user access token (of sanctum) in the prefs unless it's already saved.
  static Future<bool> setUserAccessToken(String pToken) async {
    MyLogger.info("Access token: $pToken");
    final prefs = await _instance;
    return prefs.setString(kAppUserAccessTokenPrefsKey, pToken);
    // return false;
  }

  static Future<bool> storeUserData(User userData) async {
    MyLogger.info("User data: $userData");
    final prefs = await _instance;
    try {
      await prefs.setString(
          kAppUserDataPrefsKey, json.encode(userData.toJson()));
      return true;
    } catch (e) {
      MyLogger.error(e.toString());
      return false;
    }
  }

  static User? getUserData() {
    final userData = _prefsInstance!.getString(kAppUserDataPrefsKey);
    if (userData != null) {
      return User.fromJson(json.decode(userData));
    }
    return null;
  }
}
