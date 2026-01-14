import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/chats/allchat.dart';
import 'package:Kaledal/presentation/home/navbar.dart';
import 'package:Kaledal/presentation/signup/ProgressScreen.dart';
import 'package:Kaledal/presentation/signup/singnup.dart';
import 'package:Kaledal/presentation/widgets/Buttons.dart';
import 'package:Kaledal/presentation/widgets/checkbox.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController(
    text: kDebugMode ? "saidbourtam81@gmail.com" : "",
  );

  final TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? "strin1g" : "",
  );
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("https://api.kickplayer.net/login/");
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    final body = jsonEncode({
      "email": emailController.text.trim().toLowerCase(),
      "password": passwordController.text,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save token in shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("login", emailController.text.trim());
        await prefs.setString("password", passwordController.text);
        final token = data["access_token"];
        final user_id = data["user_id"].toString();
        await prefs.setString("auth_token", token);
        await prefs.setString("user_id", user_id);

        // Check if profile is complete
        final profileUrl = Uri.parse(
            'https://api.kickplayer.net/users/$user_id/is-profile-complete');
        final profileResponse = await http.get(profileUrl, headers: {
          "Accept": "application/json",
        });

        if (profileResponse.statusCode == 200) {
          final profileData = jsonDecode(profileResponse.body);
          final isProfileComplete = profileData["completed"];

          if (isProfileComplete) {
            //if (true) {
            // Navigate to homepage
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Login successful and profile is complete!")),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            // Profile is not complete, stay on current page
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text("Login successful, but profile is incomplete.")),
            );
            // Optionally, show the fields that need to be completed (from missing_fields)
            // You can pass this information to the next page if necessary
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProgressScreen()),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to check profile completion.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid email or password")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Login failed. Check your internet connection. $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                    // SizedBox(height: 24),
                    Image.asset(
                      // 'assets/images/Frame 13.png',
                      'assets/images/Frame 13.png',
                      width: 190, // Adjust as needed
                    ),

                    SizedBox(height: 32),
                    Text(
                      'Welcome back',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    /* Text(
                      'Sign in to unlock your personalized experience!',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 24),*/
                    InputField(
                      label: 'Email*',
                      controller: emailController,
                      icon: Icons.email_outlined,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    InputField(
                      label: 'Password*',
                      controller: passwordController,
                      icon: Icons.lock_outline,
                      hintText: 'Enter your password',
                      keyboardType: TextInputType.visiblePassword,
                      isPasswordField: true,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                child: CustomCheckbox(
                                  onChanged: (bool value) {
                                    print(
                                        "Checkbox state: $value"); // Handle value in the parent widget
                                  },
                                )),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                // Toggle checkbox when text is clicked
                              },
                              child: Text(
                                'Remember me',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle forgot password action
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: mainblue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Center(
                      child: CustomButton(
                        text: 'Login',
                        color: mainblue, // Use your custom color
                        onPressed: () {
                          loginUser();
                          /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProgressScreen()),
      );*/
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
                                child: Text('Or login with',
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
                                signInWithGoogleOnly(context);
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
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Lightgrey, width: 0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                signInWithAppleOnly(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/apple.png',
                                      height: 32),
                                  SizedBox(width: 8),
                                  Text(
                                    'Apple',
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
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black, // Default text color (black)
                              fontSize: 16, // Adjust the font size as needed
                            ),
                            children: [
                              TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: "Sign up",
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
                    SizedBox(
                        height: 24), // Extra space at the bottom for scrolling
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> signInWithGoogleOnly(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        final String googleId = account.id;
        final String email = account.email;
        final String name = account.displayName ?? "";

        print('Google ID: $googleId');
        print('Email: $email');
        print('Name: $name');

        final Uri uri = Uri.parse(
          'https://api.kickplayer.net/google/signup?name=$name&email=$email&google_id=$googleId',
        );

        final response = await http.post(
          uri,
          headers: {'accept': 'application/json'},
        );

        if (response.statusCode == 200) {
          print('API Response: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Connecté : $email")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          print('Erreur API: ${response.statusCode} - ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur API: ${response.statusCode}")),
          );
        }
      } else {
        print('Connexion annulée par l’utilisateur');
      }
    } catch (e) {
      print('Erreur de connexion Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion Google")),
      );
    }
  }

  Future<void> signInWithAppleOnly(BuildContext context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String identityToken = credential.identityToken ?? '';
      final String email = credential.email ?? 'email@apple.com';
      final String name =
          '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();

      print('Identity Token: $identityToken');
      print('Email: $email');
      print('Name: $name');

      final response = await http.post(
        Uri.parse('https://api.kickplayer.net/apple/signup'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'identity_token': identityToken}),
      );

      if (response.statusCode == 200) {
        print('API Response: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connecté via Apple : $email")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print('Erreur API: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur API: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print('Erreur de connexion Apple: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion Apple")),
      );
    }
  }
}
