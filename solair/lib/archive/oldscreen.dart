import 'package:flutter/material.dart';

import '../widgets/animated_card.dart';

class oldscreen extends StatefulWidget {
  @override
  _oldscreenState createState() => _oldscreenState();
}

class _oldscreenState extends State<oldscreen> {
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
                          colors: [Color(0xFF006400), Color(0xFF32CD32)],
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
                          width: size * 0.6, // Adjust width as needed
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.075,
                              ),
                              Text(
                                'D3solaire',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .white, // Add color for better visibility
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Réduisez votre facture d'électricité, gagnez en autonomie et contribuez à sauver la planète.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors
                                      .white70, // Adjust color for better readability
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.only(left: 0),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Add your onPressed logic here
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF006400),
                                  ),
                                  label: Text(
                                    'À propos de nous',
                                    style: TextStyle(
                                      color: Color(0xFF006400),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.95),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              )
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
                      // top: 0,
                      bottom: MediaQuery.of(context).size.height * 0.1 - 75,
                      child: Container(
                          width: size,
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: CustomCard(
                                  imagePath:
                                      'Assets/sun-energy-concept-illustration_114360-6380_processed.png', // Sample image path
                                  title: ' Title $index ', // Sample title
                                  text:
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', // Sample text
                                ),
                              );
                            },
                          )))
                ])),
            /*   Expanded(
                child: Center(
              child: Container(
                height: 250,
                width: 290,
                child: YourClassName(),
              ),
            )),*/
            Container(
              child: IntrinsicWidth(
                child: ElevatedButton(
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF228B22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      side: BorderSide(
                        width: 1,
                        color: Color(0xFF228B22), // Button border color
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          'Get a free detailed quote',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.request_quote)
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        //  ),
      ),
    ));
  }
}
