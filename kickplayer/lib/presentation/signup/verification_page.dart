import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/signup/password_comdrimation.dart';
import 'package:Kaledal/presentation/signup/password_reset.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({Key? key, required this.email}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String otpCode = "";

  // Function to mask the email
  String maskEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex >= 3) {
      return email.substring(0, 3) + '*****@gmail.com';
    } else {
      return email.substring(0, atIndex) + '*****@gmail.com';
    }
  }

  // Function to verify code
  void verifyCode() {
    if (otpCode.length == 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification code entered: $otpCode'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the 4-digit verification code'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final maskedEmail = maskEmail(widget.email);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Verify Code', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Enter the 4-Digit Code Sent to Your Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Text(
                'We have sent you a reset code to $maskedEmail.',
                style: TextStyle(fontSize: 14, color: deepgrey),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 300,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 60,
                      fieldWidth: 50,
                      activeColor: mainblue,
                      inactiveColor: mainblue,
                      selectedColor: mainblue,
                      inactiveFillColor: Colors.lightBlue.shade100,
                      selectedFillColor: Colors.lightBlue.shade100,
                      activeBoxShadow: [
                        BoxShadow(
                          color: mainblue,
                          blurRadius: 0,
                          offset: Offset(0, 0),
                        ),
                      ],
                      inActiveBoxShadow: [
                        BoxShadow(
                          color: lightblue,
                          blurRadius: 0,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        otpCode = value;
                      });
                    },
                    onCompleted: (value) {},
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordConfirmation()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(text: "Didn't receive the code ? "),
                        TextSpan(
                          text: "resend",
                          style: TextStyle(
                            color: mainblue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
