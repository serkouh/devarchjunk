import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/signup/account_comfirmation.dart';

class CongratulationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Icon
              Image.asset(
                'assets/images/Frame 94.png', // Replace with your image path
                width: 100, // Adjust size if needed
                height: 100, // Adjust size if needed
              ),

              // Congratulations Text
              SizedBox(height: 20),
              Text(
                'Your Password has been changed successfully',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Green text color
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),

      // Button at the bottom of the screen
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AccountConfirmationScreen()),
            );
            // Navigator.pop(context); // Go back to the previous screen
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: mainblue,
            //  primary: mainblue, // Blue button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Rounded corners
            ),
            minimumSize:
                Size(double.infinity, 50), // Full width button with height
          ),
          child: Text(
            'Done',
            style: TextStyle(
              color: Colors.white, // White text
              fontSize: 18, // Adjust the size as needed
              fontWeight: FontWeight.bold, // Make the text bold
            ),
          ),
        ),
      ),
    );
  }
}
