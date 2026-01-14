import 'dart:async';

import 'package:flutter/material.dart';
import 'package:solair/archive/Constent.dart';

class AnimatedContainerWidgetRight extends StatefulWidget {
  @override
  _AnimatedContainerWidgetRightState createState() =>
      _AnimatedContainerWidgetRightState();
}

class _AnimatedContainerWidgetRightState
    extends State<AnimatedContainerWidgetRight> {
  double _containerWidth = 62;
  bool _isOpen = false;

  void _toggleWidth() {
    setState(() {
      _containerWidth = _containerWidth == 62 ? 240 : 62;
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleWidth,
      child: AnimatedContainer(
        margin: EdgeInsets.only(top: 5),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 130,
        height: _containerWidth,
        decoration: BoxDecoration(
          color: mainblue,
          borderRadius: _isOpen
              ? BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ) //BorderRadius.circular(15)
              : BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
        ),
        child: !_isOpen
            ? Center(
                child: RotatedBox(
                    quarterTurns: 0,
                    child: Container(
                      height: _containerWidth,
                      child: Column(children: [
                        Icon(Icons.keyboard_arrow_up, color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Devloppeur",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "d'application",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.code, color: Colors.white),
                          ],
                        ),
                      ]),
                    )),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 100,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(children: [
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
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  // Add your LinkedIn URL handling here
                                },
                                child: Image.asset(
                                  'Assets/LinkedIn_icon.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  // Add your Instagram URL handling here
                                },
                                child: Image.asset(
                                  'Assets/11f2fd963a2028fa67ce38ffe0e92bc5-Photoroom.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          )
                        ]),
                      )
                    ],
                  ),
                  SizedBox(width: 20),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          /* Text(
                            'Abderrahmane Serkouh',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.5),*/
                          /*  Text(
                            "Ingénieur informatique",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),*/
                          Text(
                            "Decouvrire un service plein d'avantage ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: GestureDetector(
                                onTap: () {
                                  // Add onPressed action for "Contact Me" button
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons
                                            .email, // Add the desired icon here
                                        color: Color(0xFF006400),
                                        size:
                                            20, // Adjust the size of the icon as needed
                                      ),
                                      SizedBox(
                                          width:
                                              5), // Add some spacing between the icon and text
                                      Text(
                                        'Contactez',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF006400)),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      )),
                ],
              ),
      ),
    );
  }
}
