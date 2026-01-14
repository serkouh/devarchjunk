import 'package:flutter/material.dart';

class resultscard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String text;

  const resultscard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        padding: EdgeInsets.only(left: 8),
        height: 50,
        width: 60 + 8,
        child: Center(
            child: Image.asset(
          imagePath,
          fit: BoxFit.fitHeight,
          width: 45,
          height: 45,
        )),
      ),
      /*  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [*/
      Container(
          padding: EdgeInsets.only(left: 8),
          width: 150,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
            ),
          )),
      SizedBox(height: 4),
      Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      /*  ],
        ),
      ),*/
    ]);
  }
}
