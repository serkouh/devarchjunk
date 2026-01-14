import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class Step2 extends StatefulWidget {
  final Function(String) onDataChanged;
  Step2({required this.onDataChanged});
  @override
  _Step2State createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  DateTime _selectedDate = DateTime.now();
  // Date picker controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Container(
            margin: EdgeInsets.only(top: 40), // Add space from the top
            width: MediaQuery.of(context).size.width *
                0.6, // 60% of the screen width
            child: H2TITLE(
              'Enter Birthday',
            ),
          ),
          /* SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),*/

          // Centered content (Date picker)
          Center(
            child: Column(
              children: [
                // Date picker displayed immediately on the screen
                SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: DatePickerWidget(
                    looping: false, // Disable infinite looping

                    initialDate: _selectedDate,
                    dateFormat: "dd-MM-yyyy", // Keep it similar to your format
                    onChange: (DateTime newDate, _) {
                      setState(() {
                        _selectedDate = newDate;
                        widget
                            .onDataChanged(newDate.toString().substring(0, 10));
                      });
                    },
                    pickerTheme: DateTimePickerTheme(
                      backgroundColor: Colors.white,
                      itemTextStyle:
                          TextStyle(color: Colors.black, fontSize: 18),
                      dividerColor:
                          Lightgrey, // Adjust to match the original UI
                    ),
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
