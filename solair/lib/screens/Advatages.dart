import 'package:flutter/material.dart';
import 'package:solair/archive/Constent.dart';

class AdvantagesCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const AdvantagesCard({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: mediumblue, // Set your desired icon color here
          ),
          SizedBox(width: 8.0),
          Text(
            text,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
