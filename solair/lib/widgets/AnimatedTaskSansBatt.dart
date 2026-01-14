import 'package:flutter/material.dart';
import 'package:solair/archive/Constent.dart';
import 'package:solair/screens/results_card.dart';

class AnimatedPopupContainerSansBatt extends StatefulWidget {
  final String panelText;
  final String inverterText;
  final String surfaceText;

  AnimatedPopupContainerSansBatt({
    required this.panelText,
    required this.inverterText,
    required this.surfaceText,
  });

  @override
  _AnimatedPopupContainerSansBattState createState() =>
      _AnimatedPopupContainerSansBattState();
}

class _AnimatedPopupContainerSansBattState
    extends State<AnimatedPopupContainerSansBatt>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000), // Set animation duration
    );
    _animation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Offscreen to the right
      end: Offset.zero, // Center of the screen
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width > 600) {
      size = 500;
    }
    return SlideTransition(
        position: _animation,
        child: Container(
            width: size * 0.9,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Image.asset(
                      "Assets/sun-energy-concept-illustration_114360-6380_processed.png",
                      height: 90,
                      width: 90,
                      fit: BoxFit.contain,
                      opacity: AlwaysStoppedAnimation(.7),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: mediumblue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Card Technique',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      resultscard(
                        imagePath:
                            'Assets/Screenshot 2024-02-28 143046-Photoroom.png-Photoroom.png',
                        title: 'Panneaux (285 Wc)',
                        text: widget.panelText,
                      ),
                      resultscard(
                        imagePath:
                            'Assets/Screenshot 2024-02-28 143309-Photoroom.png-Photoroom.png',
                        title: 'Onduleur',
                        text: widget.inverterText + " W",
                      ),
                      resultscard(
                        imagePath:
                            'Assets/Screenshot 2024-02-28 143537-Photoroom.png-Photoroom.png',
                        title: 'Surface',
                        text: widget.surfaceText + " m2",
                      ),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
