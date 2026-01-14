import 'package:flutter/material.dart';

class H1TITLE extends StatelessWidget {
  final String text;

  H1TITLE(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class H2TITLE extends StatelessWidget {
  final String text;

  const H2TITLE(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center, // Ensures text alignment
        style: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class Subtitle extends StatelessWidget {
  final String text;

  Subtitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
