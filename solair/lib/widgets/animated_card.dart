import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class CustomCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String text;

  const CustomCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late Timer _timer;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (cardKey.currentState != null) {
        cardKey.currentState!.toggleCard();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width > 600) {
      size = 500;
    }
    return FlipCard(
      key: cardKey,
      direction: FlipDirection.HORIZONTAL,
      front: Container(
        height: 140,
        width: 140,
        constraints: BoxConstraints(maxWidth: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 65,
              padding: EdgeInsets.only(top: 8),
              child: Image.asset(
                widget.imagePath,
                height: 62,
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              height: 35,
              padding: EdgeInsets.only(right: 8, left: 8),
              child: Center(
                child: Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      back: Container(
        height: 132,
        width: size * 0.4,
        constraints: BoxConstraints(maxWidth: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
