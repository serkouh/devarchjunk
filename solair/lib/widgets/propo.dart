import 'package:flutter/material.dart';
import 'package:solair/archive/Constent.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimatedContainerFromLeft extends StatefulWidget {
  @override
  _AnimatedContainerFromLeftState createState() =>
      _AnimatedContainerFromLeftState();
}

class _AnimatedContainerFromLeftState extends State<AnimatedContainerFromLeft>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Adjust animation duration
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // Use the provided start position
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width > 600) {
      size = 500;
    }
    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: () {
          luchD3solaire();
        },
        child: Container(
          width: size * 0.45,
          padding: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_forward,
                color: darkblue,
              ),
              SizedBox(width: 10),
              Text(
                'À propos de nous',
                style: TextStyle(
                  color: darkblue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  luchD3solaire() async {
    // Replace 'phoneNumber' with the phone number you want to call.
    var Url = "https://nexus-tech-solution.com/index.php/d3solaire/";
    try {
      // Launch email client with the predefined message
      await launchUrl(Uri.parse(Url));
    } catch (e) {
      // Handle error
      print("Error launching email client: $e");
    }
  }
}
