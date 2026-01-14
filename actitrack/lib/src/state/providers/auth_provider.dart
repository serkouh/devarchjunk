import 'package:flutter/material.dart';
import 'package:actitrack/src/models/user.dart';
import 'package:actitrack/src/services/api/auth/auth.dart';
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/utils/logging/logger.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _isAuthenticated = Prefs.getUserAccessToken() != null;
  }

  bool _isAuthenticated = Prefs.getUserAccessToken() != null;
  // bool _authErrorMessages = '';

  User? _user;
  User? get user => Prefs.getUserData();

  bool get isAuthenticated => _isAuthenticated;
  // String get authErrorMessage => _authErrorMessage;

  set isAuthenticated(bool val) {
    _isAuthenticated = val;
    notifyListeners();
  }

  bool _isAuthenticating = false;

  bool get isAuthenticating => _isAuthenticating;

  set isAuthenticating(bool val) {
    if (val != _isAuthenticating) {
      _isAuthenticating = val;
      notifyListeners();
    }
  }

  Future<bool> authenticateUser(String passcode) async {
    try {
      isAuthenticating = true;
      final Map<String, dynamic> result = await serviceLocator<AuthService>()
          .authenticateUserByPassCode(passcode);
      MyLogger.info(result);
      isAuthenticating = false;
      bool isSuccess = result['success'];
      //--------------
      // isAuthenticated = true;
      // return true;
      if (isSuccess) {
        Prefs.setUserAccessToken(result['token'] as String);
        Prefs.storeUserData(result['user']);
        // _user = User.fromJson(result['user']);
        return true;
      }
    } catch (e) {
      isAuthenticating = false;
      MyLogger.error(e);
    }
    return false;
  }
}
