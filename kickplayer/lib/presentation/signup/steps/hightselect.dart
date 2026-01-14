import 'dart:math';

import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';
import 'package:wheel_picker/wheel_picker.dart';

class HightSelect extends StatefulWidget {
  final Function(String, String) onDataChanged;
  HightSelect({required this.onDataChanged});
  @override
  _HightSelectState createState() => _HightSelectState();
}

class _HightSelectState extends State<HightSelect> {
  double _selectedHeight = 5.0; // Default height set to 5.0 feet
  bool isInches = true;

  // Adjusted height ranges
  List<double> heightsInches =
      List.generate(25, (index) => 4.0 + index * 0.25); // From 4.0 to 7.0 feet
  List<double> heightsCm = List.generate(
      81, (index) => (120 + index).toDouble()); // From 120 to 200 cm

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height * 0.4;
    double maxWidth = MediaQuery.of(context).size.width;
    double imageSize =
        ((_selectedHeight / (isInches ? 7.0 : 200.0) * (maxHeight - 100)) +
                100) // Adjust the divisor to 200
            .clamp(100.0, maxWidth)
            .clamp(100.0, maxHeight);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            width: maxWidth * 0.8,
            child: H2TITLE(
              'Select Your Height',
            ),
          ),
          SizedBox(height: 0),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 270,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: maxWidth,
                    height: maxHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: imageSize,
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                'assets/images/Group.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Image.asset(
                              'assets/images/Vector (1).png',
                              fit: BoxFit.fitHeight,
                              height: maxHeight,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -maxWidth * 0.15,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        width: maxWidth * 0.8,
                        height: maxWidth * 0.8,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: WheelPicker(
                          scrollDirection: Axis.horizontal,
                          itemCount: isInches
                              ? heightsInches.length
                              : heightsCm.length,
                          builder: (context, index) {
                            double height = isInches
                                ? heightsInches[index]
                                : heightsCm[index];
                            return Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${height.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  height: 1.5,
                                ),
                              ),
                            );
                          },
                          onIndexChanged: (index, interactionType) {
                            setState(() {
                              _selectedHeight = isInches
                                  ? heightsInches[index]
                                  : heightsCm[index];
                            });
                            widget.onDataChanged(_selectedHeight.toString(),
                                isInches ? "insh" : "cm");
                          },
                          style: WheelPickerStyle(
                            itemExtent: 100,
                            squeeze: 1,
                            diameterRatio: 1.2,
                            surroundingOpacity: .2,
                            magnification: 1.3,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Inches',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 25),
                      Transform(
                        transform: Matrix4.rotationY(
                            pi), // Flip the switch horizontally
                        alignment: Alignment.center,
                        child: Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: isInches,
                            onChanged: (value) {
                              setState(() {
                                isInches = value;
                                _selectedHeight =
                                    isInches ? heightsInches[0] : heightsCm[0];
                              });
                            },
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.white,
                            activeColor: mainblue,
                            inactiveThumbColor: mainblue,
                            trackOutlineColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                              return deepgrey;
                            }),
                            trackOutlineWidth:
                                MaterialStateProperty.resolveWith<double>(
                              (Set<MaterialState> states) {
                                return 1.0;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 25),
                      Text(
                        'CM',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
