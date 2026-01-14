import 'package:Kaledal/presentation/signup/aftersignup.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/presentation/signup/Login.dart';
import 'package:Kaledal/presentation/signup/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:audio_session/audio_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.music());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KickPlayer',
      theme: ThemeData(
        fontFamily: 'FranieVariableTest',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF161731),
          selectedItemColor: Colors.white,
          unselectedItemColor: Color.fromRGBO(158, 158, 158, 1),
        ),
      ),
      home: OnboardingScreensWidget(),
    );
  }
}
