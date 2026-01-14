import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/signup/ProgressScreen.dart';
import 'package:Kaledal/presentation/signup/congradulation.dart';
import 'package:Kaledal/presentation/signup/singnup.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AccountConfirmationScreen extends StatefulWidget {
  @override
  _AccountConfirmationScreenState createState() =>
      _AccountConfirmationScreenState();
}

class _AccountConfirmationScreenState extends State<AccountConfirmationScreen> {
  final TextEditingController pinController = TextEditingController();
  String otpCode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height, // Ensures scrolling
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Image Placeholder
                  Image.asset(
                    'assets/images/Frame 13.png',
                    width: 200, // Adjust as needed
                  ),

                  SizedBox(height: 24),
                  Text(
                    'Account Confirmation',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter the code confirmation sended to your email',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  // PIN Input Field
                  Center(
                      child: Container(
                          width: 300, // Set fixed width
                          child: PinCodeTextField(
                            appContext: context,
                            length: 4,
                            obscureText:
                                false, // Set false to display the number
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10),
                              fieldHeight:
                                  60, // Height of each field is greater than width
                              fieldWidth: 50,
                              activeColor: mainblue, // Border color when active
                              inactiveColor: mainblue,
                              selectedColor: mainblue,
                              inactiveFillColor: Colors.lightBlue
                                  .shade100, // Light blue background when inactive
                              selectedFillColor: Colors.lightBlue
                                  .shade100, // Light blue background when active
                              activeBoxShadow: [
                                BoxShadow(
                                  color: Colors
                                      .blue.shade400, // Active shadow color
                                  blurRadius: 0, // Blur radius for active state
                                  offset: Offset(
                                      0, 0), // Shadow offset for active state
                                ),
                              ],
                              inActiveBoxShadow: [
                                BoxShadow(
                                  color: Colors
                                      .blue.shade100, // Inactive shadow color
                                  blurRadius:
                                      0, // Blur radius for inactive state
                                  offset: Offset(
                                      0, 0), // Shadow offset for inactive state
                                ),
                              ],
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                otpCode = value;
                              });
                            },
                            onCompleted: (value) {
                              // Handle code completion if necessary
                            },
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            boxShadows: [], // Remove any extra shadows from the text field
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Please enter a code'
                                  : null;
                            },
                            beforeTextPaste: (text) {
                              return true;
                            },
                          ))),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle PIN submission and navigation
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgressScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainblue, // Blue submit button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: Size(double.infinity, 50), // Full width
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white, // White text
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
