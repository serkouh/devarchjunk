import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/home/navbar.dart';
import 'package:Kaledal/presentation/signup/Congrads_screen.dart';
import 'package:Kaledal/presentation/signup/steps/Final_info.dart';
import 'package:Kaledal/presentation/signup/steps/acheivements.dart';
import 'package:Kaledal/presentation/signup/steps/biethday.dart';
import 'package:Kaledal/presentation/signup/steps/coutries.dart';
import 'package:Kaledal/presentation/signup/steps/foot.dart';
import 'package:Kaledal/presentation/signup/steps/hightselect.dart';
import 'package:Kaledal/presentation/signup/steps/language.dart';
import 'package:Kaledal/presentation/signup/steps/postions.dart';
import 'package:Kaledal/presentation/signup/steps/profilecomleshion.dart';
import 'package:Kaledal/presentation/signup/steps/size_select.dart';
import 'package:Kaledal/presentation/signup/steps/wight.dart';
import 'package:Kaledal/presentation/signup/steps/wrist.dart';
import 'package:http/http.dart' as http;
import 'package:Kaledal/presentation/widgets/Buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart' as mine;
import 'package:http_parser/http_parser.dart'; // Add this line
import 'package:fluttertoast/fluttertoast.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int currentStep = 0;
  final int totalSteps = 12;
  String langage = "Arabic";
  String BirthDate = "";
  String foot = "";
  List<String> position = [];
  String wrist = "";
  String wrist_type = "";
  String size = "";
  String sizetype = "";
  String weight = "";
  String weight_type = "";
  String hight = "";
  String hight_type = "";
  File? profileimage;
  File? profile_video;
  String telephone = "";
  String adress = "";
  String teamname = "";
  String country = "";
  String leagues_won = "";
  String mvps = "";
  String best_player = "";
  // List of steps
  List<Widget> steps = [];

  // Handle step change
// Helper function to show toast
  void showErrorToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> nextStep(BuildContext context) async {
    if (currentStep < totalSteps) {
      // Validate data based on step
      if (currentStep == 0) {
        if (langage.isEmpty) {
          showErrorToast(context, "Please select a language");
          return;
        }
      } else if (currentStep == 1) {
        if (BirthDate.isEmpty) {
          showErrorToast(context, "Please enter your birth date");
          return;
        }
      } else if (currentStep == 2) {
        if (foot.isEmpty) {
          showErrorToast(context, "Please enter your foot size");
          return;
        }
        var body = {
          "language": langage,
          "birthday": BirthDate,
          "preferred_foot": foot,
        };
        print(body);
        await updateProfile(body);
      } else if (currentStep == 3) {
        if (position.isEmpty) {
          showErrorToast(context, "Please select a position");
          return;
        }
        _sendPositionDataToApi();
      }
      if (currentStep == 4) {
        if (wrist.isEmpty || wrist_type.isEmpty) {
          showErrorToast(
              context, "Please enter your wrist size and select a unit");
          return;
        }
      } else if (currentStep == 5) {
        if (size.isEmpty || sizetype.isEmpty) {
          showErrorToast(
              context, "Please enter your hips size and select a unit");
          return;
        }
      } else if (currentStep == 6) {
        if (weight.isEmpty || weight_type.isEmpty) {
          showErrorToast(context, "Please enter your weight and select a unit");
          return;
        }
      } else if (currentStep == 7) {
        if (hight.isEmpty || hight_type.isEmpty) {
          showErrorToast(context, "Please enter your height and select a unit");
          return;
        }
        updateMeasurements();
      } else if (currentStep == 8) {
        if (profileimage == null || profile_video == null) {
          showErrorToast(context, "Please upload both profile image and video");
          return;
        }
        await uploadMedia(profileimage!, profile_video!);
      } else if (currentStep == 9) {
        if (telephone.isEmpty || adress.isEmpty || teamname.isEmpty) {
          showErrorToast(context, "Please fill in all personal details");
          return;
        }
        var body = {
          "phone_number": telephone,
          "address": adress,
          "current_league": teamname,
        };
        updateProfile(body);
        setState(() {
          if (currentStep != 11) currentStep++;
        });
        return;
      } else if (currentStep == 10) {
        if (country.isEmpty) {
          showErrorToast(context, "Please select a country");
          return;
        }
        var body = {
          "nationality": country,
        };
        await updateProfile(body);
      } else if (currentStep == 11) {
        if (best_player.isEmpty || leagues_won.isEmpty || mvps.isEmpty) {
          showErrorToast(context, "Please fill in all achievements");
          return;
        }
        var body = {
          "leagues_won": int.parse(leagues_won),
          "mvps": int.parse(mvps),
          "best_player": int.parse(best_player)
        };
        Acheivement(body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileCreatedScreen(),
          ),
        );
        return;
      }

      setState(() {
        if (currentStep != 11) currentStep++;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    steps = [
      Step1(
        onDataChanged: (text) {
          print("/////////////");
          print(langage);
          setState(() {
            langage = text;
          });
        },
      ),
      Step2(
        onDataChanged: (text) {
          setState(() {
            BirthDate = text;
          });
        },
      ),
      FootSelection(
        onDataChanged: (text) {
          setState(() {
            foot = text;
          });
        },
      ),
      PositionSelection(
        onDataChanged: (text) {
          setState(() {
            position = text;
          });
        },
      ),
      WristSelection(
        onDataChanged: (text, type) {
          setState(() {
            wrist = text;
            wrist_type = type;
          });
        },
      ),
      SizeSelection(
        onDataChanged: (text, type) {
          setState(() {
            size = text;
            sizetype = type;
          });
        },
      ),
      WeightSelection(
        onDataChanged: (text, Type) {
          setState(() {
            weight = text;
            weight_type = Type;
          });
        },
      ),
      HightSelect(
        onDataChanged: (text, type) {
          setState(() {
            hight = text;
            hight_type = type;
          });
        },
      ),
      ProfileUploadScreen(
        onDataChanged: (image) {
          setState(() {
            profileimage = image;
          });
        },
        onDataChangedv: (video) {
          setState(() {
            profile_video = video;
          });
        },
      ),
      UserInfoScreen(
        address: (text) {
          setState(() {
            adress = text;
          });
        },
        phoneNumber: (text) {
          setState(() {
            telephone = text;
          });
        },
        teamName: (text) {
          setState(() {
            teamname = text;
          });
        },
      ),
      coutries(
        onDataChanged: (text) {
          setState(() {
            country = text;
          });
        },
      ),
      AchievementEntryScreen(
        setBestPlayerData: (p0) {
          setState(() {
            best_player = p0;
          });
        },
        setLeagueData: (p0) {
          setState(() {
            leagues_won = p0;
          });
        },
        setMVPData: (p0) {
          setState(() {
            mvps = p0;
          });
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Hide the app bar height completely
        child: Container(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Back Icon
                InkWell(
                  onTap: () {
                    if (currentStep > 0) {
                      setState(() {
                        currentStep--;
                      });
                    }
                  },
                  child: const Icon(Icons.arrow_back, size: 30),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7, // 80% width
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Lightgrey, // Background color of the progress bar
                    ),
                    child: LinearProgressIndicator(
                      value:
                          (currentStep + 1) / totalSteps, // Progress bar value
                      backgroundColor: Colors
                          .transparent, // Transparent background to show the custom color
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Handle forward action here
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
            // Step content
            Expanded(child: Center(child: steps[currentStep])),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CustomButton(
                    text: currentStep == totalSteps - 1 ? 'Finish' : 'Next',
                    color: mainblue, // Use your custom color
                    onPressed: () {
                      nextStep(context);
                      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProgressScreen()),
      );*/
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile(Map<String, dynamic> jsonData) async {
    try {
      // Get the user ID and token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString(
          'user_id'); // Assuming user_id is saved in SharedPreferences
      String? token = prefs.getString(
          'auth_token'); // Assuming token is saved in SharedPreferences

      if (userId == null || token == null) {
        print("User ID or Token not found in SharedPreferences");
        return;
      }

      // Create the API URL using the user ID
      final apiUrl = 'https://api.kickplayer.net/update-profile/$userId';

      // Set the headers for the request with the token
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token', // Adding the token to the headers
      };

      // Make the POST request with the passed JSON data
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(jsonData), // Send the JSON body as it is passed
      );
      print(jsonData);
      print(apiUrl);
      print(response.body);
      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        print('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> Acheivement(Map<String, dynamic> jsonData) async {
    try {
      // Get the user ID and token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString(
          'user_id'); // Assuming user_id is saved in SharedPreferences
      String? token = prefs.getString(
          'auth_token'); // Assuming token is saved in SharedPreferences

      if (userId == null || token == null) {
        print("User ID or Token not found in SharedPreferences");
        return;
      }

      // Create the API URL using the user ID
      final apiUrl = 'https://api.kickplayer.net/add-achievement/$userId';

      // Set the headers for the request with the token
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token', // Adding the token to the headers
      };

      // Make the POST request with the passed JSON data
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(jsonData), // Send the JSON body as it is passed
      );
      print(jsonData);
      print(apiUrl);
      print(response.body);
      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        print('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _sendPositionDataToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs
        .getString('user_id'); // Assuming user_id is saved in SharedPreferences
    final Map<String, int> positionIds = {
      'Goalkeeper': 1,
      'Right Back': 2,
      'Left Back': 3,
      'Center Back 1': 4,
      'Center Back 2': 5,
      'Defensive Midfielder': 6,
      'Central Midfielder': 7,
      'Attacking Midfielder': 8,
      'Right Winger': 9,
      'Left Winger': 10,
      'Striker': 11,
    };
    List<int> positionIdsToSend = position
        .map((entry) => positionIds[entry])
        .where((id) => id != null)
        .cast<int>()
        .toList();
    // Prepare the data to send in the request body
    final Map<String, dynamic> requestData = {
      'position_ids': positionIdsToSend,
    };
    print(requestData);

    // Send the POST request
    final response = await http.post(
      Uri.parse('https://api.kickplayer.net/add-positions/$userId'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestData),
    );
    print(response.body);
    if (response.statusCode == 200) {
      // Successfully sent the data
      print('Successfully sent position data: ${response.body}');
    } else {
      // Handle error
      print('Failed to send data. Status code: ${response.statusCode}');
    }
  }

  Future<void> updateMeasurements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs
        .getString('user_id'); // Assuming user_id is saved in SharedPreferences
    final url = 'https://api.kickplayer.net/add-measurements/$userId';

    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "wrist_size": double.parse(wrist),
      "wrist_unit": wrist_type,
      "hips_size": double.parse(size),
      "hips_unit": sizetype,
      "weight": double.parse(weight),
      "weight_unit": weight_type,
      "height": double.parse(hight),
      "height_unit": hight_type
    });

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        print('Successfully updated measurements!');
      } else {
        print(
            'Failed to update measurements. Status code: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> uploadMedia(File profileImageFile, File profileVideoFile) async {
    print("Starting uploadMedia function...");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    print("User ID retrieved: $userId");

    if (userId == null) {
      print("Error: User ID not found in SharedPreferences.");
      return;
    }
    _showLoading();
    var url =
        Uri.parse('https://api.kickplayer.net/upload-profile-media/$userId');
    print("API URL: $url");

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers['accept'] = 'application/json';

      // Attach image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          profileImageFile.path,
          filename: path.basename(profileImageFile.path),
          contentType: MediaType('image', 'png'),
        ),
      );

      // Attach video file
      request.files.add(
        await http.MultipartFile.fromPath(
          'introduction_video',
          profileVideoFile.path,
          filename: path.basename(profileVideoFile.path),
          contentType: MediaType('video', 'mp4'),
        ),
      );

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        print("Upload successful!");
      } else {
        print("Upload failed: ${response.body}");
      }
    } catch (e) {
      print("Exception during upload: $e");
    }
    _hideLoading();
  }

  bool _isLoading = false;

  void _showLoading() {
    setState(() => _isLoading = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoading() {
    setState(() => _isLoading = false);
    Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
  }
}
