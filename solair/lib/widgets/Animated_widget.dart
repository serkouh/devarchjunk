import 'package:flutter/material.dart';

class AnimatedCustomButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color buttonColor;
  final bool last;
  final VoidCallback onPressed;
  final Offset startPosition; // New parameter to define starting position

  const AnimatedCustomButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.last,
    required this.buttonColor,
    required this.onPressed,
    this.startPosition =
        const Offset(1.0, 0.0), // Default value for starting position
  }) : super(key: key);

  @override
  _AnimatedCustomButtonState createState() => _AnimatedCustomButtonState();
}

class _AnimatedCustomButtonState extends State<AnimatedCustomButton>
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
      begin: widget.startPosition, // Use the provided start position
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
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 30),
        height: 40,
        width: size * 0.8,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomLeft: widget.last ? Radius.zero : Radius.circular(20.0),
                bottomRight: widget.last ? Radius.zero : Radius.circular(20.0),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Icon(widget.icon, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
