import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';

class VirtualAcademyPage extends StatefulWidget {
  @override
  _VirtualAcademyPageState createState() => _VirtualAcademyPageState();
}

class _VirtualAcademyPageState extends State<VirtualAcademyPage> {
  bool isOverlayVisible = true; // Flag to control visibility of the overlay

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.transparent),
          onPressed: () {},
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Virtual Academy',
          style: TextStyle(
            color: deepBlueColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  "What should I know?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: deepBlueColor,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/043d5f5631ab29e0f81a8007d79f3324.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(Icons.play_circle_fill,
                            color: Colors.white, size: 50),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Pick your Learning zone",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: deepBlueColor,
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/Frame 3.png',
                      width: 300,
                      height: 300,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
          // Overlay with blur effect and text (Stacked on top of the content)
          if (isOverlayVisible)
            GestureDetector(
              onTap: () {
                setState(() {
                  isOverlayVisible = false; // Hide the overlay on tap
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.4), // Dim the background
                child: Stack(
                  children: [
                    // The blurred background
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: Container(
                        color:
                            Colors.black.withOpacity(0.6), // Dim the background
                      ),
                    ),
                    // The overlay content
                    Center(
                      child: Text(
                        'Coming Soon',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 0.0, bottom: 16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[100],
            foregroundColor: deepBlueColor,
            shape: StadiumBorder(),
            padding: EdgeInsets.only(left: 20, right: 0, top: 0),
          ),
          onPressed: () {
            // Optionally, you can hide the overlay here as well
            setState(() {
              isOverlayVisible =
                  false; // Hide the overlay when the button is pressed
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Talk With kickplayer AI"),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: deepBlueColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

PieChartSectionData _buildPieSection(String title, double value, Color color) {
  return PieChartSectionData(
    value: value,
    color: color,
    radius: 80,
    title: "$value%",
    titleStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    badgeWidget: _buildBadge(title),
    badgePositionPercentageOffset: 1.2,
  );
}

Widget _buildBadge(String text) {
  return Container(
    width: 70,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

class _PieData {
  final String title;
  final double value;
  final Color color;

  _PieData(this.title, this.value, this.color);
}
