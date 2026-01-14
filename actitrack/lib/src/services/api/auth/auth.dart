import 'dart:convert';

import 'package:actitrack/src/models/user.dart';
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:actitrack/src/services/http_client.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:actitrack/src/utils/logging/logger.dart';

abstract class AuthClassTemplate {
  Future authenticateUserByPassCode(String passcode);
  Future logOutUser(String passcode);
}

class AuthService implements AuthClassTemplate {
  final AppHttpClient appHttpClient;

  AuthService({
    required this.appHttpClient,
  });

  @override
  Future authenticateUserByPassCode(String passcode) async {
    // Map<String, dynamic> retVal = {"success": true};
    // try {
    //   await Future.delayed(const Duration(milliseconds: 1800));
    //   //TODO: check the passcode validaty
    // } catch (e) {
    //   MyLogger.error(e);
    // }
    // return retVal;

    Map<String, dynamic> retVal = {"success": false};
    try {
      bool isAppOnline = await FuncHelpers.checkIfOnline();

      if (!isAppOnline) {
        throw Exception('No internet connection');
      }

      MyLogger.info('Authenticating user with passcode: $passcode');
      final response =
          await appHttpClient.postRequest('/login/animateur', data: {
        'auth_code': passcode,
      });

      if (response.statusCode == 200) {
        MyLogger.info('User authenticated successfully');
        final data = jsonDecode(response.body);
        retVal['success'] = true;
        retVal['token'] = data['token'];
        retVal['user'] = User.fromJson(data['user']);
        return retVal;
      } else {
        throw Exception('Failed to authenticate user');
      }
    } catch (e) {
      MyLogger.error(e);
    }
    return retVal;
  }

  @override
  Future logOutUser(String passcode) {
    // TODO: implement logOutUser
    throw UnimplementedError();
  }
}
