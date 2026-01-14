import 'dart:async';
import 'package:Kaledal/presentation/home/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/signup/Login.dart';
import 'package:video_player/video_player.dart';

class VideoScreenAfterSignUp extends StatefulWidget {
  @override
  _VideoScreenAfterSignUpState createState() => _VideoScreenAfterSignUpState();
}

class _VideoScreenAfterSignUpState extends State<VideoScreenAfterSignUp> {
  List<VideoPlayerController> _controllers = [];
  int _currentStep = 0;

  final List<Map<String, String>> _steps = [
    {
      "title": "Welcome to KickPlayer",
      "description":
          "This isn't just another app. It's a starting point.\nFor every player who ever believed they could make it.",
      "video": "assets/videos/Kick1720.mp4"
    },
    {
      "title": "Why We Exist",
      "description":
          "We built KickPlayer for the talented player with no spotlight.\nHere, your phone becomes your pitch. Your effort becomes your profile.\nAnd the right people are watching.",
      "video": "assets/videos/Kick2720.mp4"
    },
    {
      "title": "How It Works",
      "description":
          "Complete football challenges. Upload your videos.\nEvery touch, every run, every goal is scored by our AI and shown worldwide.",
      "video": "assets/videos/Kic3720.mp4"
    },
    {
      "title": "The Journey Starts Now",
      "description":
          "You don’t need a big club to start.\nYou need belief, consistency, and the right platform.\nYou’ve got the first two, we’re here to be the third.",
      "video": "assets/videos/Kick4.mp4"
    },
  ];

  @override
  void initState() {
    super.initState();
    _preloadVideos();
  }

  void _preloadVideos() async {
    for (var i = 0; i < _steps.length; i++) {
      final controller = VideoPlayerController.asset(_steps[i]['video']!);
      await controller.initialize();
      controller.setLooping(false);
      controller.addListener(() {
        if (controller.value.position >= controller.value.duration && mounted) {
          _goToNextStep();
        }
      });
      _controllers.add(controller);
    }

    setState(() {
      _controllers[_currentStep].play();
    });
  }

  void _goToNextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _controllers[_currentStep].pause();
        _currentStep++;
        _controllers[_currentStep].seekTo(Duration.zero);
        _controllers[_currentStep].play();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _controllers.isNotEmpty &&
                    _controllers[_currentStep].value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controllers[_currentStep].value.aspectRatio,
                    child: VideoPlayer(_controllers[_currentStep]),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top,
            child: Container(color: Colors.white),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: Image.asset("assets/images/whitelogo.png",
                width: 100, height: 60),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF161731).withOpacity(0),
                            Color(0xFF161731),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.06 - 5,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.19,
                      color: Color(0xFF161731),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              _steps[_currentStep]['title']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              _steps[_currentStep]['description']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(_steps.length, (index) {
                              return _buildProgressIndicator(index);
                            }),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: 3,
      decoration: BoxDecoration(
        color: index <= _currentStep ? Colors.white : deepgrey,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
