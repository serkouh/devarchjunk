import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/home/navbar.dart';
import 'package:Kaledal/presentation/signup/Contract.dart';
import 'package:Kaledal/presentation/signup/Login.dart';
import 'package:Kaledal/presentation/signup/verification_page.dart';
import 'package:Kaledal/presentation/widgets/Buttons.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';
import 'package:Kaledal/presentation/widgets/checkbox.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isTermsChecked = false;
  bool isContractChecked = false;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _signUp() async {
    if (_fullNameController.text.isEmpty) {
      _showSnackBar("Full name is required.");
      return;
    }

    // Validate email format
    if (_emailController.text.isEmpty) {
      _showSnackBar("Email is required.");
      return;
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(_emailController.text)) {
      _showSnackBar("Please enter a valid email address.");
      return;
    }

    // Validate password
    if (_passwordController.text.isEmpty) {
      _showSnackBar("Password is required.");
      return;
    }

    // Validate confirm password
    if (_confirmPasswordController.text.isEmpty) {
      _showSnackBar("Confirm password is required.");
      return;
    }

    if (!isTermsChecked || !isContractChecked) {
      _showSnackBar('Please accept terms and conditions');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Passwords do not match');
      return;
    } // Check empty fields

    // Check password match

    setState(() => isLoading = true);

    final url = Uri.parse('https://api.kickplayer.net/signup/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      },
      body: jsonEncode({
        'full_name': _fullNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        "confirm_password": _passwordController.text,
      }),
    );

    setState(() => isLoading = false);
    print(response.statusCode);
    print(response.body);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
                //email: _emailController.text,
                )),
      );
      /*  final token = data['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
     
      _showSnackBar('Signup successful!');
      Navigator.pushReplacementNamed(context, '/login');*/
    } else {
      _showSnackBar(data['detail']);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Frame 13.png',
                    width: 200, // Adjust as needed
                  ),
                  SizedBox(height: 24),
                  H1TITLE(
                    'Get Started',
                  ),
                  SizedBox(height: 8),
                  Subtitle(
                    'Create an account to enjoy new experience.',
                  ),
                  SizedBox(height: 24),
                  InputField(
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    label: 'Full Name*',
                    icon: Icons.person_outline,
                    hintText: 'Enter your full name',
                  ),
                  SizedBox(height: 16),
                  InputField(
                    controller: _emailController,
                    label: 'Email*',
                    icon: Icons.email_outlined,
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  InputField(
                    controller: _passwordController,
                    label: 'Password*',
                    icon: Icons.lock_outline,
                    hintText: 'Enter your password',
                    keyboardType: TextInputType.visiblePassword,
                    isPasswordField: true,
                  ),
                  SizedBox(height: 16),
                  InputField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password*',
                    icon: Icons.lock_outline,
                    hintText: 'Confirm your password',
                    keyboardType: TextInputType.visiblePassword,
                    isPasswordField: true,
                  ),
                  SizedBox(height: 16),
                  // Terms and Conditions checkbox
                  Row(
                    children: [
                      CustomCheckbox(
                        onChanged: (value) {
                          setState(() {
                            isTermsChecked = value!;
                          });
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              isTermsChecked = !isTermsChecked;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black), // Default text style
                              children: [
                                TextSpan(
                                  text: 'I accept ',
                                  style: TextStyle(
                                      fontWeight: FontWeight
                                          .normal), // Normal weight for the first part
                                ),
                                TextSpan(
                                  text: 'privacy policy',
                                  style: TextStyle(
                                      fontWeight: FontWeight
                                          .bold), // Bold for privacy policy
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: TextStyle(
                                      fontWeight: FontWeight
                                          .normal), // Normal weight again
                                ),
                                TextSpan(
                                  text: 'terms and conditions',
                                  style: TextStyle(
                                      fontWeight: FontWeight
                                          .bold), // Bold for terms and conditions
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      CustomCheckbox(
                        onChanged: (value) {
                          setState(() {
                            isContractChecked = value;
                          });
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContractPage()),
                          );
                          setState(() {
                            isContractChecked = !isContractChecked;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black), // Default text style
                            children: [
                              TextSpan(text: 'I agree to the '), // Normal text
                              TextSpan(
                                text:
                                    'Kick Player', // Bold text for "Kick Player"
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' Contract'), // Normal text
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: CustomButton(
                      text: 'Sign Up',
                      color: mainblue, // Use your custom color
                      onPressed: () {
                        _signUp();
                      },
                    ),
                  ),

                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: deepgrey,
                            thickness: 0.5,
                            endIndent: 10, // Space before text
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Or signup with',
                                  style: TextStyle(
                                    color: deepgrey,
                                    fontSize: 14, // Adjust the size as needed
                                    fontWeight: FontWeight.w500,
                                  )),
                            )),
                        Expanded(
                          child: Divider(
                            color: deepgrey,
                            thickness: 0.5,
                            indent: 10, // Space after text
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 6),
                  // Google and Facebook buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Lightgrey, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/image 17.png',
                                    height: 32),
                                SizedBox(width: 8),
                                Text(
                                  'Google',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Lightgrey, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Handle Facebook login
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/images/Facebook_Logo_Primary 1.png',
                                    height: 32),
                                SizedBox(width: 8),
                                Text(
                                  'Facebook',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black, // Default text color (black)
                            fontSize: 16, // Adjust the font size as needed
                          ),
                          children: [
                            TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: "Login",
                              style: TextStyle(
                                color: mainblue, // Sign up text color (blue)
                                fontWeight:
                                    FontWeight.bold, // Optional: Make it bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
