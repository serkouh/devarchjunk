import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/signup/verification_page.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void sendResetLink() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset link sent to ${emailController.text}'),
        ),
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerificationScreen(
                email: "wwww@gmail.com",
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Password Reset', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the start
            children: [
              SizedBox(height: 20), // Push content down
              Text(
                'Enter Your Email Address', // **Title**
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Text(
                'We will send you a reset code', // **Subtitle**
                style: TextStyle(fontSize: 14, color: deepgrey),
              ),

              Form(
                key: _formKey,
                child: InputField(
                  label: '',
                  icon: Icons.email_outlined,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: sendResetLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainblue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text('Send', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
