import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solair/archive/Constent.dart';
import 'package:solair/screens/dialog.dart';
import 'package:solair/screens/tabiew.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solair/widgets/Animated_widget.dart';
import 'package:solair/widgets/propo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../widgets/animated_card.dart';

class EnergyCalculatorPage extends StatefulWidget {
  @override
  _EnergyCalculatorPageState createState() => _EnergyCalculatorPageState();
}

class _EnergyCalculatorPageState extends State<EnergyCalculatorPage> {
  bool _isSwitched = true;
  double _inputValue = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _textFieldController = TextEditingController();
  String displayText = "Calculer avec votre facture mensuelle";
  bool clicked = false;

  List<InvestmentInfo> investmentInfos = [
    InvestmentInfo(
      imagePath: 'Assets/soalr.png',
      title: "Pourquoi l'énergie solaire ?",
      text:
          "Le solaire est l'un des meilleurs investissements que vous puissiez faire et voici pourquoi",
    ),
    InvestmentInfo(
      imagePath: 'Assets/biomass-icon-Photoroom.png',
      title: 'Sécurité',
      text: "Devenez propriétaire de votre propre source d'energie",
    ),
    InvestmentInfo(
      imagePath:
          'Assets/Screenshot 2024-02-28 132751-Photoroom.png-Photoroom.png',
      title: 'Durabilité',
      text:
          "Profiter de plus de 20ans d'électricité gratuite en adoptant la soution",
    ),
    InvestmentInfo(
      imagePath:
          'Assets/Screenshot 2024-02-28 131127-Photoroom.png-Photoroom.png',
      title: 'Environnement',
      text: "Protégez-vous et votre planete  pour un future vert",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width > 600) {
      size = 500;
    }
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Stack(children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [darkblue, LightBlue],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      child: Stack(children: [
                        Positioned(
                          left: 16,
                          top: 0,
                          bottom: 0,
                          width: size * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'D3solaire',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Évaluez vos besoins en quelques clics et obtenez une vision claire avant de prendre une décision.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8),
                              AnimatedContainerFromLeft(),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: MediaQuery.of(context).size.height * 0.05,
                          //bottom: 0,
                          width: size * 0.45, // Adjust width as needed
                          child: Image.asset(
                            'Assets/AdobeStock_465867127-1-scaled_processed-removebg-preview.png',
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      ])),
                  Positioned(
                    left: 0,
                    bottom: MediaQuery.of(context).size.height * 0.1 - 70,
                    child: Container(
                      width: size,
                      height: 140,
                      child: AnimatedList(
                        scrollDirection: Axis.horizontal,
                        initialItemCount: investmentInfos.length,
                        itemBuilder: (context, index, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CustomCard(
                                imagePath: investmentInfos[index].imagePath,
                                title: investmentInfos[index].title,
                                text: investmentInfos[index].text,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ])),
            SizedBox(
              height: 15,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.5 - 120,
                width: size,
                child: Stack(children: [
                  Positioned(
                    left: 10,
                    top: 50,
                    child: Opacity(
                        opacity: 0.5, // Set the opacity value (0.0 to 1.0)
                        child: Image.asset(
                          'Assets/ezgif-5-89e0e93d3c-removebg-preview.png',
                          width: 150,
                          height: 150,
                        )),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Opacity(
                        opacity: 0.5, // Set the opacity value (0.0 to 1.0)
                        child: Image.asset(
                          'Assets/ezgif-5-483f3db2b0-removebg-preview.png',
                          width: 150,
                          height: 150,
                        )),
                  ),
                  Center(
                      child: Container(
                          width: size * 0.75,
                          height: 250,
                          child: Column(
                            children: [
                              Container(
                                  width: size * 0.75, // 70% of screen width
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          20), // Adds 20 horizontal paddings
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (!_isSwitched) {
                                            displayText =
                                                "Calculer avec votre facture mensuelle ";
                                          } else {
                                            displayText =
                                                "Calculer avec votre consomation mensuelle ";
                                          }
                                          _isSwitched = !_isSwitched;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: size * 0.75 - 150,
                                            child: Center(
                                              child: Text(
                                                displayText,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize:
                                                      14, // Adjust the font size as needed
                                                  color: Colors
                                                      .black, // You can change the text color
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: _isSwitched
                                                  ? mediumblue
                                                  : Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Center(
                                                child: Text(
                                              "Dh",
                                              style: TextStyle(
                                                color: _isSwitched
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontWeight: _isSwitched
                                                    ? FontWeight.bold
                                                    : null,
                                              ),
                                            )),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: !_isSwitched
                                                  ? mediumblue
                                                  : Colors.grey[400],
                                              borderRadius: BorderRadius.circular(
                                                  8), // Optional: Set border radius for rounded corners
                                            ),
                                            padding: EdgeInsets.all(
                                                8), // Optional: Add padding for inner content
                                            child: Center(
                                              child: Text(
                                                "Kwh", // Your text content
                                                style: TextStyle(
                                                  color: !_isSwitched
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: !_isSwitched
                                                      ? FontWeight.bold
                                                      : null,
                                                ),
                                              ),
                                            ),
                                          )

                                          /* Icon(Icons.loop,
                                              color: darkblue, size: 30),*/
                                        ],
                                      ))),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  width: size * 0.6,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 208, 228,
                                        244), // Use a very light green color
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust border radius as needed
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: _textFieldController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: darkblue),
                                    decoration: InputDecoration(
                                      labelText:
                                          'Enter ${_isSwitched ? 'le montant' : ' les Kilowatts'}',
                                      labelStyle: TextStyle(color: darkblue),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: darkblue),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: darkblue),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: Icon(
                                        _isSwitched
                                            ? Icons.receipt
                                            : Icons.flash_on,
                                        color: darkblue,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _inputValue =
                                            double.tryParse(value) ?? 0;
                                      });
                                    },
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (_textFieldController.text != '') {
                                    // If user is already signed in, navigate directly
                                    _navigateToYourPage();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Entrez une valeur',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                                icon:
                                    Icon(Icons.calculate, color: Colors.white),
                                label: Text(
                                  'Simuler',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mediumblue,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ],
                          )))
                ])),
            Spacer(),
            AnimatedCustomButton(
              last: true,
              startPosition: Offset(0.0, 1.0),
              text: 'Obtenez un devis détaillé gratuit.',
              icon: Icons.request_quote,
              buttonColor: mediumblue,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog();
                  },
                );
              },
            ),
          ],
        ),
        //  ),
      ),
    ));
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google Sign In failed');
    }

    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;
    if (googleAuth == null) {
      throw Exception('Google Authentication failed');
    }

    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user!.displayName);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', userCredential.user!.displayName ?? '');
    prefs.setString('email', userCredential.user!.email ?? '');

    return userCredential;
  }

  Future<bool> _handleGoogleSignIn() async {
    try {
      await signInWithGoogle();
      _navigateToYourPage();

      return true;
    } catch (error) {
      // Handle sign-in error
      print('Error signing in with Google: $error');
      // You can show an error message to the user if required
    }
    return false;
  }

  void _navigateToYourPage() {
    EasyLoading.show(
      status: 'Calculating your installation',
    );
    Future.delayed(Duration(seconds: 2), () {
      EasyLoading.dismiss();
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              YourClassName(
            kwh: (_isSwitched ? _inputValue / 1.5193 : _inputValue).toString(),
          ),
          transitionDuration: Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.bounceIn;
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    });
  }

  void showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'Assets/Screenshot 2024-03-08 161947-fococlipping-standard.png', // Add your image asset path
                  width: 150,
                ),
                SizedBox(height: 20),
                Text(
                  "Login Required",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Veuillez vous connecter avec Google pour voir les résultats.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _handleGoogleSignIn();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mediumblue, // Choose your button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'Assets/download-removebg-preview (26).png', // Add your Google icon asset path
                          width: 20, color: Colors.white,
                        ),
                        SizedBox(
                            width: 10), // Add spacing between the icon and text
                        Text(
                          "Login with Google",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  luchD3solaire() async {
    // Replace 'phoneNumber' with the phone number you want to call.
    var Url = "https://nexus-tech-solution.com/index.php/d3solaire/";
    try {
      // Launch email client with the predefined message
      await launchUrl(Uri.parse(Url));
    } catch (e) {
      // Handle error
      print("Error launching email client: $e");
    }
  }
}

class InvestmentInfo {
  final String imagePath;
  final String title;
  final String text;

  InvestmentInfo(
      {required this.imagePath, required this.title, required this.text});
}
