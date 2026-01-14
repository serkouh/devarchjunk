import 'package:flutter/material.dart';
import 'dart:math';

import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';

class WeightSelection extends StatefulWidget {
  final Function(String, String) onDataChanged;
  WeightSelection({required this.onDataChanged});
  @override
  _WeightSelectionState createState() => _WeightSelectionState();
}

class _WeightSelectionState extends State<WeightSelection> {
  TextEditingController _weightController = TextEditingController();
  double _weight = 0.0;
  bool isKg = true;

  @override
  Widget build(BuildContext context) {
    double scaleWidth = MediaQuery.of(context).size.width * 0.8;
    double maxWeight = isKg ? 160.0 : 330.0; // 160kg ~ 330lbs
    double maxAngle = pi; // 180 degrees in radians
    double rotationAngle =
        (_weight / maxWeight) * maxAngle; // Calculate rotation based on weight

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 40), // Add space from the top
              width: MediaQuery.of(context).size.width *
                  0.8, // 80% of the screen width
              child: H2TITLE(
                'Select Your Weight',
              ),
            ),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                // Circle for the scale (for visual purposes)
                Container(
                  width: scaleWidth,
                  height: scaleWidth,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                // Image of the balance
                Image.asset(
                  'assets/images/balance.png',
                  width: scaleWidth,
                  fit: BoxFit.contain,
                ),
                // Needle indicating weight (black, longer, below the scale image)
                /* Positioned(
                  top: scaleWidth /
                      2, // Aligning the bottom of the needle with the center of the scale
                  child: Transform.rotate(
                    // Rotate the needle around its bottom
                    angle: rotationAngle -
                        pi / 2, // Offset needle by -90 degrees to start from 0
                    child: Container(
                      width: 4, // Making the needle thicker
                      height: 150, // Making the needle longer
                      color: Colors.black, // Changing the needle color to black
                    ),
                  ),
                ), */
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20), // Reduced padding for smaller screens
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                textAlign:
                    TextAlign.center, // Center the text inside the TextField
                style: TextStyle(
                  fontSize: 32, // Increase the font size
                  fontWeight: FontWeight
                      .bold, // Make the font bold for better visibility
                ),
                decoration: InputDecoration(
                  hintText: '00', // Shorter hint text
                  hintStyle: TextStyle(
                    color: deepgrey, // Make hint text grey
                    fontSize: 32, // Same size as the text for consistency
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black, width: 1), // Black border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1), // Black border when focused
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _weight = double.tryParse(value) ?? 0.0;
                  });
                  widget.onDataChanged(_weight.toString(), isKg ? "kg" : "pd");
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kg',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 25),
                Transform.scale(
                  scale: 1.5,
                  child: Switch(
                    value: isKg,
                    onChanged: (value) {
                      setState(() {
                        isKg = value;
                        _weight = 0.0;
                        _weightController.clear();
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
                        return 1.0; // Thinner outline
                      },
                    ),
                  ),
                ),
                SizedBox(width: 25),
                Text(
                  'Pounds',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
