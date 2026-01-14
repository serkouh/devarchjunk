import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solair/archive/Constent.dart';
import 'package:solair/widgets/DataSelector.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDevelopper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width > 600) {
      size = 500;
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: size * 0.9,
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
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 75, // Adjust the width as needed
                  height: 75, // Adjust the height as needed
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        10), // Adjust the radius as needed
                    image: DecorationImage(
                      image: AssetImage('Assets/1678050926025.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Abderrahmane serkouh',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: darkblue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Chef project ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Utilisez notre expertise pour concrétiser votre idée dans le monde réel.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            _buildButton(
              'WhatsApp',
              () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomSelector(
                      me: '0',
                      type: '0',
                    );
                  },
                );
              },
              'Assets/whatsapp-line-logo-icon-2048x2048-059kk1vz.png',
              darkgreen, // Keeping the original color as green
            ),
            _buildButton(
              'Linkdin',
              luchLinkdin,
              'Assets/Linkedin-icon-png-Photoroom.png',
              LightBlue, // Keeping the original color as orange
            ),
            _buildButton(
              'Email',
              () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomSelector(
                      me: '0',
                      type: '1',
                    );
                  },
                );
              },
              'Assets/Screenshot 2024-03-03 211848-Photoroom.png-Photoroom.png',
              darkblue, // Using a shade of blue
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

  Widget _buildButton(
      String text, Function() onPressed, String imageAsset, Color buttonColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: buttonColor, // Button color
            // onPrimary: Colors.white, // Text color
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  imageAsset,
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*
  _launchWhatsApp(String phone, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('username') ?? 'YourName';

    String phoneNumber = "0657278870";

    String message =
        "Bonjour, $userName. J'aimerais prendre rendez-vous pour une consultation concernant un projet de développement informatique à la date $date. Mon numéro de téléphone est $phone.";

    String url = "https://wa.me/$phoneNumber/?text=${Uri.encodeFull(message)}";

    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print("Error launching WhatsApp: $e");
    }
  }

  _sendEmail(String phone, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('username') ?? 'YourName';

    String message =
        "Bonjour, $userName. J'aimerais prendre rendez-vous pour une consultation concernant un projet de développement informatique à la date $date. Mon numéro de téléphone est $phone.";

    String emailAddress = "contact.support@nexus-tech-solution.com";
    String emailUrl =
        "mailto:$emailAddress?body=${Uri.encodeComponent(message)}";

    try {
      await launchUrl(Uri.parse(emailUrl));
    } catch (e) {
      print("Error launching email client: $e");
    }
  }
*/
  luchLinkdin() async {
    var Url = "https://www.linkedin.com/in/abderrahmane-serkouh/";
    try {
      await launchUrl(Uri.parse(Url));
    } catch (e) {
      print("Error launching email client: $e");
    }
  }
}

void showContactDevelopper(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ContactDevelopper();
    },
  );
}
