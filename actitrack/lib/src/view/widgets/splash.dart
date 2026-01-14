import 'dart:async';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/config/constants/constants.dart';
import 'package:actitrack/src/config/constants/palette.dart';
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:actitrack/src/state/providers/auth_provider.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    final String? passcode = Prefs.getPassCode();

    if (passcode != null) {
      try {
        bool res =
            await context.read<AuthProvider>().authenticateUser(passcode);
        if (res) {
          Prefs.setPassCode(passcode);
          // Future.delayed(const Duration(milliseconds: 800), () {
          // Navigator.of(context).pushNamedAndRemoveUntil(kHomeRoute, (route) => false);
          Navigator.of(context).pushReplacementNamed(kHomeRoute);
          context.read<AuthProvider>().isAuthenticated = true;
          // Navigator.pushNamed(context, kHomeRoute);
        } else {
          Navigator.of(context).pushReplacementNamed(kAuthRoute);
        }
      } catch (e) {
        MyLogger.error(e);
        Navigator.of(context).pushReplacementNamed(kAuthRoute);
      }
    } else {
      print('Error: Auth token not found');
      Navigator.of(context).pushReplacementNamed(kAuthRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Assets.kPng_Brochure,
              width: 150,
            ),
            SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200.0),
                child: LinearProgressIndicator(
                  color: kPrimaryColor,
                  backgroundColor: Color(0xFFF5F5F5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
