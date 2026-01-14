import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';
import 'package:wheel_picker/wheel_picker.dart';

class WristSelection extends StatefulWidget {
  final Function(String, String) onDataChanged;
  WristSelection({required this.onDataChanged});

  @override
  _WristSelectionState createState() => _WristSelectionState();
}

class _WristSelectionState extends State<WristSelection> {
  double _selectedSize = 6.0;
  bool isInches = true;

  // Sizes in inches, incrementing by 1
  List<double> sizesInches =
      List.generate(4, (index) => 5.0 + index); // Sizes: 5.0, 6.0, 7.0, 8.0

  // Sizes in cm, incrementing by 1 cm for each step
  List<double> sizesCm = List.generate(
      4, (index) => 12.0 + index); // Sizes: 12.0, 13.0, 14.0, 15.0

  late WheelPickerController sizeController;

  @override
  void initState() {
    super.initState();
    sizeController = WheelPickerController(
      itemCount: isInches ? sizesInches.length : sizesCm.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height * 0.6;
    double maxSize = MediaQuery.of(context).size.width;
    double imageSize = isInches
        ? ((_selectedSize / 12 * (MediaQuery.of(context).size.width - 200)) +
            200)
        : ((_selectedSize / 25 * (MediaQuery.of(context).size.width - 200)) +
            200);

    imageSize = imageSize.clamp(200.0, maxSize).clamp(200.0, maxHeight);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 40),
              width: MediaQuery.of(context).size.width * 0.8,
              child: H2TITLE('Enter your sizes?'),
            ),

            // Container for the image and wheel picker
            Container(
              width: double.infinity,
              height: maxHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Image displayed above the wheel picker
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: imageSize,
                            height: imageSize,
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/images/braslet 2.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Square WheelPicker Container
                  Positioned(
                    bottom: -MediaQuery.of(context).size.width * 0.10,
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
                                  '${size.toStringAsFixed(1)}',
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
                                widget.onDataChanged(_selectedSize.toString(),
                                    isInches ? "in" : "cm");
                              });
                            },
                            style: WheelPickerStyle(
                              itemExtent: 100,
                              squeeze: 1,
                              diameterRatio: 1.2,
                              surroundingOpacity: .2,
                              magnification: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Switch for Inches and CM
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
                            transform: Matrix4.rotationY(pi),
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
                            )),
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
