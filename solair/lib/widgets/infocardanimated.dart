import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedInfoCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String image;

  const AnimatedInfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.image,
  }) : super(key: key);

  @override
  _AnimatedInfoCardState createState() => _AnimatedInfoCardState();
}

class _AnimatedInfoCardState extends State<AnimatedInfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: Offset(0.0, (1 - _animation.value) * 50),
            child: _buildCard(),
          ),
        );
      },
    );
  }

  Widget _buildCard() {
    double size = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width > 600) {
      size = 500;
    }
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: size * 0.42,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [widget.color, Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "Assets/${widget.image}",
                  height: 35,
                  width: 35,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 8),
                Text(
                  widget.value,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              height: 38,
              child: Center(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
