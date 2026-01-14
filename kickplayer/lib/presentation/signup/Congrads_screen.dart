import 'package:Kaledal/presentation/signup/aftersignup.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/home/navbar.dart';

class ProfileCreatedScreen extends StatelessWidget {
  const ProfileCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background decorative icons
          Positioned(
            top: 100,
            left: -30,
            child: _circleDecoration(),
          ),
          Positioned(
            top: 500,
            right: 20,
            child: _circleDecoration(),
          ),
          Positioned(
            bottom: 200,
            left: -10,
            child: _circleDecoration(),
          ),
          Positioned(
            bottom: 100,
            right: -25,
            child: _circleDecoration(),
          ),

          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 32),
                  _profileCircleImage(context),
                  const SizedBox(height: 32),
                  const Text(
                    'Well done!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your profile has been created successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "You're now part of the kickplayer community.\nStart your journey and unlock your full\npotential on and off the pitch.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoScreenAfterSignUp(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainblue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Explore Kickplayer',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/vector.png',
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileCircleImage(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.7;
    return Container(
      padding: const EdgeInsets.all(6),
      child: Image.asset(
        'assets/images/b2207098bab8c99d185a3904f8fee68b.png',
        width: imageWidth,
        height: imageWidth, // keep it square
      ),
    );
  }

  Widget _circleDecoration() {
    return Image.asset(
      'assets/images/Ellipse 113.png',
      width: 40,
      height: 40,
    );
  }
}
