import 'dart:async';

import 'package:flutter/material.dart';
import 'package:solair/archive/Constent.dart';

class AnimatedContainerWidgetLeft extends StatefulWidget {
  @override
  _AnimatedContainerWidgetLeftState createState() =>
      _AnimatedContainerWidgetLeftState();
}

class _AnimatedContainerWidgetLeftState
    extends State<AnimatedContainerWidgetLeft> {
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
                                  "Syndic",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "digital",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Icon(Icons.computer, color: Colors.white),
                          ],
                        ),
                      ]),
                    )),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 20),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Center(
                              child: Container(
                            width: 75,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(
                                    'Assets/output-onlinepngtools.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          )),
                          Center(
                              child: Container(
                                  width: 90,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          // Add your LinkedIn URL handling here
                                        },
                                        child: Image.asset(
                                          'Assets/YouTube_full-color_icon_(2017).png',
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
                                  ))),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Révolutionnez votre syndic avec la digitalisation.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                // Ajoutez l'action onPressed pour le bouton "Me contacter"
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
                                      Icons.explore,
                                      color: Color(0xFF006400),
                                      size:
                                          20, // Ajustez la taille de l'icône si nécessaire
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ), // Ajoutez un peu d'espace entre l'icône et le texte
                                    Text(
                                      'Découvrir', // Corrigez le texte ici
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF006400)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
      ),
    );
  }
}
