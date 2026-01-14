import 'dart:convert';
import 'package:Kaledal/presentation/chats/allchat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/Buttons.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementUpdateScreen extends StatefulWidget {
  final Function onSuccess; // The callback function passed from the parent

  // Constructor accepting the onSuccess callback
  AchievementUpdateScreen({required this.onSuccess});

  @override
  _AchievementUpdateScreenState createState() =>
      _AchievementUpdateScreenState();
}

class _AchievementUpdateScreenState extends State<AchievementUpdateScreen> {
  final List<Map<String, dynamic>> achievements = [
    {"name": "League", "icon": Icons.sports_soccer},
    {"name": "MVP", "icon": Icons.star},
    {"name": "Best Player of the Year", "icon": Icons.sports},
  ];

  Map<String, TextEditingController> achievementControllers = {};

  String leagues_won = '';
  String mvps = '';
  String best_player = '';

  @override
  void initState() {
    super.initState();
    for (var achievement in achievements) {
      achievementControllers[achievement["name"]] = TextEditingController();
    }
  }

  @override
  void dispose() {
    achievementControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> updateAchievement() async {
    Map<String, int> achievementCounts = {};
    achievementControllers.forEach((achievement, controller) {
      final text = controller.text.trim();
      if (text.isNotEmpty) {
        achievementCounts[achievement] = int.tryParse(text) ?? 0;
      }
    });

    // Create body for the request
    var body = {
      "leagues_won": int.tryParse(leagues_won) ?? 0,
      "mvps": int.tryParse(mvps) ?? 0,
      "best_player": int.tryParse(best_player) ?? 0,
    };
    print(body);
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
      };

      // Make the POST request with the passed JSON data
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body), // Send the JSON body as it is passed
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Achievements updated successfully')),
        );
        widget.onSuccess();
        Navigator.pop(context);
      } else {
        print('Failed to update achievements: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update achievements')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: deepBlueColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Update Achievements", // Dynamically use the title parameter here
          style: TextStyle(fontSize: 18, color: deepBlueColor),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MessagesScreen()),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(
                'assets/images/messages icon.png',
                width: 30,
                height: 30,
                color: mainblue,
              ),
            ),
          ),
        ],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title for Achievements
            Container(
              margin: EdgeInsets.only(top: 40),
              width: MediaQuery.of(context).size.width * 0.8,
              child: H2TITLE('Enter your achievement'),
            ),
            SizedBox(height: 75),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                  'The achievement',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                  'Number of times',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              )
            ]),

            // Input for achievements
            Expanded(
              child: ListView.builder(
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(achievement["icon"], color: Colors.blue, size: 28),
                        SizedBox(width: 10),
                        Expanded(child: Text(achievement["name"])),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller:
                                achievementControllers[achievement["name"]],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "0",
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                            ),
                            onChanged: (text) {
                              setState(() {
                                if (achievement["name"] == "League") {
                                  leagues_won = text;
                                } else if (achievement["name"] == "MVP") {
                                  mvps = text;
                                } else if (achievement["name"] ==
                                    "Best Player of the Year") {
                                  best_player = text;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Update Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: CustomButton(
                  text: 'Update Achievements',
                  color: Colors.blue, // Use your custom color
                  onPressed: () {
                    updateAchievement();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
