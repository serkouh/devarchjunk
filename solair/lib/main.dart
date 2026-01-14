import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:solair/archive/Constent.dart';
import 'package:solair/screens/entry_point.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isWeb = identical(0, 0.0);

  FirebaseOptions firebaseOptions = isWeb
      ? FirebaseOptions(
          apiKey: "AIzaSyDXIlkSYvQUacx5wjhq7WxX1xvvwgolda8",
          authDomain: "solarapp-11449.firebaseapp.com",
          projectId: "solarapp-11449",
          storageBucket: "solarapp-11449.appspot.com",
          messagingSenderId: "1019401975348",
          appId: "1:1019401975348:web:6e07ba57cb4e9e7caf7c61",
          measurementId: "G-G3TJ4W3F80")
      : DefaultFirebaseOptions.currentPlatform;
  await Firebase.initializeApp(
    options: firebaseOptions,
  );
  final runnableApp = _buildRunnableApp(
    isWeb: kIsWeb,
    webAppWidth: 500.0,
    app: const MyApp(),
  );

  runApp(runnableApp);
}

Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }

  return Center(
    child: ClipRect(
      child: SizedBox(
        width: webAppWidth,
        child: app,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = darkblue
      ..maskColor = darkblue
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = darkblue
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.white
      ..userInteractions = true
      ..animationStyle = EasyLoadingAnimationStyle.scale
      ..animationDuration = Duration(milliseconds: 250)
      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    configLoading();
    final MaterialColor customColor = MaterialColor(0xFF004F98, <int, Color>{
      50: Color(0xFFE1EEFA),
      100: Color(0xFFB4D4F0),
      200: Color(0xFF85B9E5),
      300: Color(0xFF569EDB),
      400: Color(0xFF328DDB),
      500: Color(0xFF007CCB),
      600: Color(0xFF0072BD),
      700: Color(0xFF0068AF),
      800: Color(0xFF005E9F),
      900: Color(0xFF004F98),
    });
    return MaterialApp(
      title: 'Simulateur Solaire',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: customColor,
      ),
      home: EnergyCalculatorPage(),
      color: Colors.white,
      builder: EasyLoading.init(),
    );
  }
}
