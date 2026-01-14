import 'package:flutter/material.dart';

class OliveCurvedRectanglePainter extends CustomPainter {
  final Color? bgColor;
  OliveCurvedRectanglePainter({this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final curveHeight = 40.0; 

    final paint = Paint()..color = bgColor ?? Colors.white;

    final path = Path()
      ..moveTo(0, curveHeight)
      ..lineTo(0, height)
      ..lineTo(width, height)
      ..lineTo(width, curveHeight)
      ..quadraticBezierTo(width / 2, 0, 0, curveHeight);

    // final borderPaint = Paint()
    //   ..color = Colors.white
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 10;
    // canvas.drawPath(path, paint);
    // canvas.drawPath(path, borderPaint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(OliveCurvedRectanglePainter oldDelegate) => false;
}
