import 'dart:math';

import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';
import 'package:wheel_picker/wheel_picker.dart';

class SizeSelection extends StatefulWidget {
  final Function(String, String) onDataChanged;
  SizeSelection({required this.onDataChanged});
  @override
  _SizeSelectionState createState() => _SizeSelectionState();
}

class _SizeSelectionState extends State<SizeSelection> {
  double _selectedSize = 28.0; // Start from 28 inches (or around 71 cm)
  bool isInches = true;

  // Use a more realistic range for waist sizes
  List<double> sizesInches =
      List.generate(15, (index) => 28.0 + index * 2.0); // Increment by 2 inches
  List<double> sizesCm = List.generate(
      15, (index) => (28.0 + index * 2.0) * 2.54); // Convert to cm

  late WheelPickerController sizeController;

  @override
  void initState() {
    super.initState();
    sizeController = WheelPickerController(
        itemCount: isInches ? sizesInches.length : sizesCm.length);
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height * 0.4;
    double maxSize = MediaQuery.of(context).size.width;
    double imageSize =
        ((_selectedSize / (isInches ? 12 : 30) * (maxHeight - 100)) + 100)
            .clamp(100.0, maxSize)
            .clamp(100.0, maxHeight);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Added to handle overflow
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(top: 40),
                width: MediaQuery.of(context).size.width * 0.8,
                child: H2TITLE('Select Your Size')),
            Container(
              width: double.infinity,
              height: maxHeight + 130, // Increased height flexibility
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: maxHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: double.infinity),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: imageSize,
                            alignment: Alignment.bottomCenter,
                            child: Image.asset(
                              'assets/images/Group.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -MediaQuery.of(context).size.width * 0.15,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: WheelPicker(
                            scrollDirection: Axis.horizontal,
                            controller: sizeController,
                            builder: (context, index) {
                              double size = isInches
                                  ? sizesInches[index]
                                  : sizesCm[index];
                              return Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '${size.toStringAsFixed(1)} ',
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
                                _selectedSize = isInches
                                    ? sizesInches[index]
                                    : sizesCm[index];
                              });
                              widget.onDataChanged(_selectedSize.toString(),
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
                                  _selectedSize =
                                      isInches ? sizesInches[0] : sizesCm[0];
                                  sizeController = WheelPickerController(
                                      itemCount: isInches
                                          ? sizesInches.length
                                          : sizesCm.length);
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
                                },
                              ),
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
