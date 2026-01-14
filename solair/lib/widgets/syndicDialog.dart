import 'dart:math';

import 'package:flutter/material.dart';
import 'package:solair/archive/Constent.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Colors.white,
            width: 2.0, // Border width
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 5.0),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  "Assets/Untitleesign-removebg-preview.png",
                  height: 200,
                  fit: BoxFit.fitHeight,
                ),
                Image.asset(
                  "Assets/bT6xb7REVULdxbV2TgGDE-transformed.png",
                  height: 200,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Syndic en un clic',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkblue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Découvrez votre nouvel outil pour une meilleure ville résidentielle",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                lucHSYNDIC();
              },
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              label: Text(
                'See More',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkblue,
                elevation: 0, // Removes shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String generateRandomText() {
    final random = Random();
    final textOptions = [
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
      'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'
    ];
    return textOptions[random.nextInt(textOptions.length)];
  }

  lucHSYNDIC() async {
    // Replace 'phoneNumber' with the phone number you want to call.
    var Url = "https://nexus-tech-solution.com/index.php/syndic-en-un-clic/";
    try {
      // Launch email client with the predefined message
      await launchUrl(Uri.parse(Url));
    } catch (e) {
      // Handle error
      print("Error launching email client: $e");
    }
  }
}

void showImageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ImageDialog();
    },
  );
}
