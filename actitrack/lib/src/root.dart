import 'package:actitrack/src/view/widgets/splash.dart';
import 'package:flutter/material.dart';
import 'package:actitrack/src/state/providers/auth_provider.dart';
import 'package:actitrack/src/view/screens/main/auth/auth_screen.dart';
import 'package:actitrack/src/view/screens/main/home/home_screen.dart';
import 'package:provider/provider.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, AuthProvider authProvider, _) {
        return /*authProvider.isAuthenticated ? HomeScreen() :*/ SplashScreen();
      },
    );
  }
}
