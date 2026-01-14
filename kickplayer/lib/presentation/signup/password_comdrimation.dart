import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/signup/account_comfirmation.dart';
import 'package:Kaledal/presentation/signup/congradulation.dart';
import 'package:Kaledal/presentation/signup/verification_page.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart';

class PasswordConfirmation extends StatefulWidget {
  @override
  _PasswordConfirmationState createState() => _PasswordConfirmationState();
}

class _PasswordConfirmationState extends State<PasswordConfirmation> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void sendResetLink() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset successful'),
        ),
      );
      // Navigate to the next screen after reset
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CongratulationsPage()),
      );
    }
  }

  // Validator for password matching
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  // Validator for confirm password matching
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Password Reset ', style: TextStyle(color: Colors.black)),
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
              /* SizedBox(height: 20),
                Text(
                'Enter Your New Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Text(
                'Please enter a new password and confirm it',
                style: TextStyle(fontSize: 14, color: deepgrey),
              ),
              SizedBox(height: 20),*/

              // Password Field
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //  SizedBox(height: 16),
                    InputField(
                      label: 'Enter Your New Password*',
                      icon: Icons.lock_outline,
                      hintText: 'Enter your password',
                      keyboardType: TextInputType.visiblePassword,
                      isPasswordField: true,
                    ),
                    SizedBox(height: 16),
                    InputField(
                      label: 'Confirm Your New Password*',
                      icon: Icons.lock_outline,
                      hintText: 'Confirm your password',
                      keyboardType: TextInputType.visiblePassword,
                      isPasswordField: true,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Submit Button
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
                child: Text('Comfirm', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
