import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/signup/Login.dart';
import 'package:video_player/video_player.dart';

class VideoStepScreen extends StatefulWidget {
  @override
  _VideoStepScreenState createState() => _VideoStepScreenState();
}

class _VideoStepScreenState extends State<VideoStepScreen> {
  late VideoPlayerController _controller;
  int _currentStep = 0;

  // List of step titles
  final List<String> _titles = [
    "Step 1: Introduction",
    "Step 2: Preparation",
    "Step 3: Execution",
    "Step 4: Completion"
  ];

  // List of video URLs
  final List<String> _videoUrls = [
    "https://videos.pexels.com/video-files/6077689/6077689-uhd_1440_2560_25fps.mp4",
    "https://videos.pexels.com/video-files/6077687/6077687-uhd_1440_2560_25fps.mp4",
    "https://videos.pexels.com/video-files/6077715/6077715-uhd_1440_2560_25fps.mp4",
    "https://videos.pexels.com/video-files/10349008/10349008-uhd_1440_2732_25fps.mp4"
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _startStepProgression();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(_videoUrls[_currentStep])
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  void _startStepProgression() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentStep < _videoUrls.length - 1) {
        setState(() {
          _currentStep++;
          _controller.dispose(); // Dispose previous controller
          _initializeVideo(); // Load new video
        });
      } else {
        timer.cancel(); // Stop the timer once all steps are done
        // Navigate to the login page after completing the video steps
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginPage()), // Replace with your login page widget
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
          // Video Player
          Positioned.fill(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Center(
                    child:
                        CircularProgressIndicator()), // Show loading indicator
          ),
          // White background for status bar area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top,
            child: Container(color: Colors.white),
          ),
          // Logo
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            // right: 0,
            child: Image.asset("assets/images/whitelogo.png",
                width: 100, height: 60),
          ),
          // Bottom progress area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.23,
              child: Stack(
                children: [
                  // Gradient effect
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
                  // Step Progression
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.06 - 5,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.17 + 5,
                      color: Color(0xFF161731),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _titles[_currentStep], // Dynamic title
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(4, (index) {
                              return _buildContainer(index);
                            }),
                          ),
                          SizedBox(height: 30),
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

  Widget _buildContainer(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: 3,
      decoration: BoxDecoration(
        color: index <= _currentStep
            ? Colors.white
            : deepgrey, // White for current step, Grey for others
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
