import 'package:flutter/material.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';

class AchievementEntryScreen extends StatefulWidget {
  final Function(String) setLeagueData;
  final Function(String) setMVPData;
  final Function(String) setBestPlayerData;

  // Constructor that accepts the functions as parameters
  AchievementEntryScreen({
    required this.setLeagueData,
    required this.setMVPData,
    required this.setBestPlayerData,
  });

  @override
  _AchievementEntryScreenState createState() => _AchievementEntryScreenState();
}

class _AchievementEntryScreenState extends State<AchievementEntryScreen> {
  final List<Map<String, dynamic>> achievements = [
    {"name": "League", "icon": Icons.sports_soccer},
    {"name": "MVP", "icon": Icons.star},
    {"name": "Best Player of the Year", "icon": Icons.sports},
  ];

  Map<String, TextEditingController> achievementControllers = {};

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

  void _submitAchievements() {
    Map<String, int> achievementCounts = {};
    achievementControllers.forEach((achievement, controller) {
      final text = controller.text.trim();
      if (text.isNotEmpty) {
        achievementCounts[achievement] = int.tryParse(text) ?? 0;
      }
    });

    print("User Achievements:");
    achievementCounts.forEach((key, value) {
      print("$key: $value times");
    });

    // Pass data to backend or next screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title for Achievements
            Container(
              margin: EdgeInsets.only(top: 40), // Add space from the top
              width: MediaQuery.of(context).size.width *
                  0.8, // 60% of the screen width
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

            // Input for scores
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
                              print(text);
                              if (achievement["name"] == "League") {
                                widget.setLeagueData(text);
                              } else if (achievement["name"] == "MVP") {
                                widget.setMVPData(text);
                              } else if (achievement["name"] ==
                                  "Best Player of the Year") {
                                widget.setBestPlayerData(text);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
