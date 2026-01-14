import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';

class InfoContainer extends StatelessWidget {
  final String label;
  final String value;

  const InfoContainer({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 80),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: superlightblue, // Blue background color
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 12, color: deepBlueColor), // White text for label
          ),
          SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: deepBlueColor), // White text for value
          ),
        ],
      ),
    );
  }
}
