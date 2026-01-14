import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solair/archive/Constent.dart';
import 'package:solair/screens/Advatages.dart';
import 'package:solair/widgets/DataSelector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'Assets/Screenshot 2024-03-03 203737-Photoroom.png',
              fit: BoxFit.fitHeight,
              width: double.infinity,
              height: 150.0,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Nous-Contacter',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Obtenez un devis personnalisé ou posez vos questions à travers nos médias.",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  /*   AdvantagesCard(
                    icon: FontAwesomeIcons.solidCheckCircle,
                    text: "Avoir un devis professionnel",
                  ),
                  AdvantagesCard(
                    icon: FontAwesomeIcons.clock,
                    text: "Obtention rapide",
                  ),
                  AdvantagesCard(
                    icon: FontAwesomeIcons.fileAlt,
                    text: "Précis",
                  ),
                  AdvantagesCard(
                    icon: FontAwesomeIcons.handshake,
                    text: "Gratuit",
                  ),*/
                  SizedBox(height: 20.0),
                  _buildButton(
                    'WhatsApp',
                    () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomSelector(
                            me: '1',
                            type: '0',
                          );
                        },
                      );
                    },
                    'Assets/whatsapp-line-logo-icon-2048x2048-059kk1vz.png',
                    darkgreen, // Keeping the original color as green
                  ),
                  _buildButton(
                    'Email',
                    () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomSelector(
                            me: '1',
                            type: '1',
                          );
                        },
                      );
                    },
                    'Assets/Screenshot 2024-03-03 211848-Photoroom.png-Photoroom.png',
                    darkblue, // Using a shade of blue
                  ),
                  _buildButton(
                    'Phone Call',
                    _makePhoneCall,
                    'Assets/3374f84310d608d74314b06797d29822-Photoroom.png',
                    LightBlue, // Keeping the original color as orange
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      String text, Function() onPressed, String imageAsset, Color buttonColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
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
            //  onPrimary: Colors.white,
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
                style: TextStyle(fontSize: 16),
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

    String message =
        "Bonjour, $userName. J'aimerais prendre rendez-vous pour une consultation concernant un projet de développement informatique à la date $date. Mon numéro de téléphone est $phone.";
    String phoneNumber = "0657278870";
    String url = "https://wa.me/$phoneNumber/?text=${Uri.encodeFull(message)}";

    try {
      // Launch WhatsApp with the predefined message
      await launchUrl(Uri.parse(url));
    } catch (e) {
      // Handle error
      print("Error launching WhatsApp: $e");
    }
  }

  _sendEmail(String phone, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('username') ?? 'YourName';

    String message =
        "Bonjour, $userName. J'aimerais prendre rendez-vous pour une consultation concernant un projet de développement informatique à la date $date. Mon numéro de téléphone est $phone.";
    String emailAddress =
        "contact.support@nexus-tech-solution.com"; // Replace with recipient's email address
    String emailUrl =
        "mailto:$emailAddress?body=${Uri.encodeComponent(message)}";

    try {
      // Launch email client with the predefined message
      await launchUrl(Uri.parse(emailUrl));
    } catch (e) {
      // Handle error
      print("Error launching email client: $e");
    }
  }
*/

  _makePhoneCall() async {
    // Replace 'phoneNumber' with the phone number you want to call.
    var phoneUrl = "tel:+212645112146";
    try {
      // Launch email client with the predefined message
      await launchUrl(Uri.parse(phoneUrl));
    } catch (e) {
      // Handle error
      print("Error launching email client: $e");
    }
  }
}
