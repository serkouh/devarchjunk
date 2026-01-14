import 'dart:convert';

import 'package:Kaledal/presentation/home/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Kaledal/presentation/signup/Login.dart';
import 'package:Kaledal/presentation/signup/ProgressScreen.dart';
import 'package:Kaledal/presentation/signup/welcome_screen.dart';

import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreensWidget extends StatefulWidget {
  @override
  _OnboardingScreensWidgetState createState() =>
      _OnboardingScreensWidgetState();
}

class _OnboardingScreensWidgetState extends State<OnboardingScreensWidget> {
  late VideoPlayerController _controller;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    // 1. Initialise la vidéo
    _controller = VideoPlayerController.asset('assets/images/spll.mov')
      ..initialize().then((_) {
        if (mounted) setState(() {});
        _controller
          ..play()
          ..setLooping(false);
      });

    // 2. Attend 5 s mini puis tente l’auto-login
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) autoLoginUser();
    });
  }

  Future<void> autoLoginUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('login');
    final storedPassword = prefs.getString('password');

    // Si aucune coordonnée stockée → page de connexion
    if (storedEmail == null || storedPassword == null) {
      _goToLogin();
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse('https://api.kickplayer.net/login/');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = jsonEncode({
      'email': storedEmail,
      'password': storedPassword,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        final userId = data['user_id'].toString();

        await prefs
          ..setString('auth_token', token)
          ..setString('user_id', userId);

        // Vérifie la complétude du profil
        final profileUrl = Uri.parse(
          'https://api.kickplayer.net/users/$userId/is-profile-complete',
        );
        final profileResponse = await http.get(profileUrl, headers: {
          'Accept': 'application/json',
        });

        if (profileResponse.statusCode == 200) {
          final profileData = jsonDecode(profileResponse.body);
          final isProfileComplete = profileData['completed'] as bool;

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  isProfileComplete ? HomeScreen() : ProgressScreen(),
            ),
          );
        } else {
          _goToLogin(
              message:
                  'Erreur lors de la vérification du profil (code ${profileResponse.statusCode}).');
        }
      } else {
        _goToLogin(message: 'Échec de la reconnexion automatique.');
      }
    } catch (e) {
      _goToLogin(message: 'Erreur réseau : $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _goToLogin({String? message}) {
    if (!mounted) return;
    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(), // Show loading spinner while video is initializing
      ),
    );
  }
}
