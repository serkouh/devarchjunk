import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/signup/password_reset.dart';
import 'package:signature/signature.dart'; // Import the signature package

class ContractPage extends StatefulWidget {
  @override
  _ContractPageState createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  late SignatureController
      _signatureController; // Controller for the signature pad
  bool isSigned = false;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 5,
      onDrawEnd: () {
        setState(() {
          isSigned = _signatureController.isNotEmpty;
        });
      },
    );
  }

  // Function to handle signing action
  void signContract() {
    if (_signatureController.isNotEmpty) {
      setState(() {
        isSigned = true;
      });
    }
  }

  // Function to retry signing
  void retrySign() {
    setState(() {
      _signatureController.clear();
      isSigned = false;
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo image
                  Image.asset(
                    'assets/images/Frame 13.png',
                    width: 200, // Adjust as needed
                  ),
                  SizedBox(height: 24),
                  // Title text
                  Text(
                    'kickplayer Player Agreement',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  // Agreement content
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '1. Financial Support & Investment\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '• You will receive funding from football fans (investors) who believe in your potential.\n',
                        ),
                        TextSpan(
                          text:
                              '• In return, 10% of your future professional contract earnings will be distributed to your investors.\n\n',
                        ),
                        TextSpan(
                          text: '2. Kickplayer Commitment\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '• kickplayer provides development opportunities, AI-driven training insights, and career guidance to support your growth.\n',
                        ),
                        TextSpan(
                          text:
                              '• We facilitate your exposure to clubs, academies, and agents by tracking your progress and showcasing your talent.\n\n',
                        ),
                        TextSpan(
                          text: '3. Revenue Share & Platform Fees\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '• kickplayer will receive a percentage of any future transfer fees when you sign a professional contract.\n',
                        ),
                        TextSpan(
                          text:
                              '• Transactions made by investors on the platform are subject to a small service fee.\n\n',
                        ),
                        TextSpan(
                          text: '4. Data & Performance Tracking\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '• Your training, match footage, and performance metrics will be analyzed and stored securely within the platform.\n',
                        ),
                        TextSpan(
                          text:
                              '• Clubs, academies, and agents will have access to your development records for scouting purposes.\n\n',
                        ),
                        TextSpan(
                          text: '5. Commitment to Development\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '• You agree to actively engage in training, AI-driven challenges, and mentorship programs to enhance your skills.\n',
                        ),
                        TextSpan(
                          text:
                              '• You commit to maintaining discipline and professionalism to maximize your chances of success.\n\n',
                        ),
                        TextSpan(
                          text: 'Agreement Confirmation\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'By proceeding, you confirm that you understand and accept these terms. This agreement is designed to create a fair and transparent ecosystem where all participants—players, investors, and clubs—benefit from Kickplayer innovative football development model.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  // Signature area
                  Text(
                    'Please sign below to confirm your agreement:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  // Signature pad
                  Container(
                    color: Lightgrey,
                    height: 200,
                    child: Signature(
                      controller: _signatureController,
                      height: 200,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),
                  // Retry and confirm buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: retrySign,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White background
                            foregroundColor: mainblue, // Blue text
                            side: BorderSide(
                                color: mainblue, width: 2), // Blue border
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // 15px border radius
                            ),
                            minimumSize:
                                Size(double.infinity, 50), // Button height 40px
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                                fontSize: 16), // Increase font size by 2px
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Spacing between buttons
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isSigned
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PasswordResetScreen()),
                                  );
                                }
                              : null, // Disable button if not signed
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainblue, // Blue background
                            foregroundColor: Colors.white, // White text
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // 15px border radius
                            ),
                            minimumSize:
                                Size(double.infinity, 50), // Button height 40px
                          ),
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                                fontSize: 16), // Increase font size by 2px
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
