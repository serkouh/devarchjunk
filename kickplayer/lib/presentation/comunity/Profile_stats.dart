import 'package:Kaledal/presentation/comunity/profile.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/comunity/posts.dart';
import 'package:Kaledal/presentation/widgets/fullname.dart';
import 'package:Kaledal/presentation/widgets/info_container.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:Kaledal/presentation/widgets/physicalattribute.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStats extends StatefulWidget {
  @override
  _ProfileStatsState createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  Map<String, dynamic>? profileData;
  List<dynamic>? positionData;
  bool isLoading = true;
  String userId = "";
  AchievementsResponse? data;
  String? fullName;
  bool isVerified = false;

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId != null) {
      final response = await http.get(
        Uri.parse('https://api.kickplayer.net/users/$userId'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          fullName = data['full_name'];
          isVerified = data['is_verified'] ?? false;
        });
      } else {
        print("Failed to load user: ${response.statusCode}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    fetchProfileData();
    fetchPositionData();
    fetchAchievements();
  }

  Future<void> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    final response =
        await http.get(Uri.parse('https://api.kickplayer.net/profile/$userId'));
    print("/////////");
    print(profileData);
    if (response.statusCode == 200) {
      setState(() {
        profileData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load profile data');
    }
  }

  Future<void> fetchAchievements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    final response = await http.get(
      Uri.parse('https://api.kickplayer.net/users/$userId/achievements'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        data = AchievementsResponse.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load achievements');
    }
  }

  Future<void> fetchPositionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    print('https://api.kickplayer.net/positions/$userId');
    try {
      final response = await http.get(
        Uri.parse('https://api.kickplayer.net/positions/$userId'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          positionData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load position data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching position data: $e');
    }
  }

  int calculateAge(String birthdayString) {
    try {
      // Try to parse in various formats
      DateTime? birthday;

      // Try ISO format (YYYY-MM-DD)
      birthday = DateTime.tryParse(birthdayString);

      // If that fails, try other common formats
      if (birthday == null) {
        final formats = [
          'MM/dd/yyyy',
          'dd-MM-yyyy',
          'yyyy/MM/dd',
          'dd.MM.yyyy',
        ];

        for (var format in formats) {
          try {
            birthday = DateFormat(format).parse(birthdayString);
            break;
          } catch (e) {
            continue;
          }
        }
      }

      if (birthday == null) {
        throw FormatException('Unable to parse birthday string');
      }

      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthday.year;

      if (currentDate.month < birthday.month ||
          (currentDate.month == birthday.month &&
              currentDate.day < birthday.day)) {
        age--;
      }

      return age;
    } catch (e) {
      print('Error calculating age: $e');
      return 0; // Return default value
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            fullName ?? "",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.ios_share,
                color: mainblue,
              ),
              onPressed: () {
                // Share functionality
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Section (Profile Picture and Header)

              Stack(
                children: [
                  // Blue Border
                  ProfilePictureWidget(
                    imageUrl: profileData?['profile_picture'] == "string"
                        ? 'https://cdn.britannica.com/69/228369-050-0B18A1F6/Asian-Cup-Final-2019-Hasan-Al-Haydos-Qatar-Japan-Takumi-Minamino.jpg'
                        : profileData?['profile_picture'],
                    borderColor: mainblue,
                  ),
                  // Green Dot in the bottom-right corner
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.green, // Green dot
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white,
                            width: 2), // White border for better visibility
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              UserNameWithVerifiedIcon(),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoContainer(
                      label: 'POSITION',
                      value:
                          (positionData?[0]['position_pos'] ?? 'Right Winger')
                              .toString()),
                  const SizedBox(width: 10),
                  InfoContainer(
                      label: 'AGE',
                      value: calculateAge(
                                  profileData?['birthday']?.toString() ?? "")
                              .toString() ??
                          '17'),
                  const SizedBox(width: 10),
                  InfoContainer(
                      label: 'NATIONALITY',
                      value: profileData?['nationality'] ?? 'Morocco'),
                ],
              ),
              SizedBox(height: 8),
              QuoteContainer(
                quoteText:
                    "The only way to do great work is to love what you do.",
                sayerName: "Steve Jobs",
              ),
              SizedBox(height: 8),
              RadarChartExample()
            ],
          ),
        ));
  }

  // Helper method for displaying the profile info
  Widget _buildInfoContainer(String label, String value) {
    return Container(
      constraints: BoxConstraints(minWidth: 80),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: mainblue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: mainblue),
          ),
          SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class QuoteContainer extends StatelessWidget {
  final String quoteText;
  final String sayerName;

  QuoteContainer({required this.quoteText, required this.sayerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 8, vertical: 8), // 16 padding left and right
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
            color: deepBlueColor.withOpacity(0.3), width: 0.5), // Thin border
        borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
      ),
      child: Column(
        // Use Column to allow text to wrap and add sayer name below the quote
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          // Quote icon and text
          Row(
            children: [
              Icon(Icons.format_quote, color: Colors.orange),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  quoteText,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: deepBlueColor,
                  ),
                  maxLines: 6,
                  textAlign: TextAlign.justify, // Allow text to wrap and align
                  overflow:
                      TextOverflow.ellipsis, // In case the text is too long
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Space between quote and sayer's name
          // Sayer's name at the bottom right
          Align(
            alignment: Alignment.centerRight, // Align sayer's name to the right
            child: Text(
              '- $sayerName',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: deepBlueColor),
            ),
          ),
        ],
      ),
    );
  }
}

class RadarChartExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scores = [4, 3, 5, 2, 4, 3];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attribute overview',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: deepBlueColor),
          ),
          SizedBox(height: 8),
          Container(
              height: 300,
              width: double.infinity,
              padding: EdgeInsets.all(24.0), // 24 padding
              decoration: BoxDecoration(
                color: superlightblue, // Blue background color
                borderRadius: BorderRadius.circular(12), // Border radius of 24
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            200, // Set an appropriate height to prevent overflow
                        width: 200, // Set the width of the radar chart
                        child: RadarChart(
                          RadarChartData(
                            radarBackgroundColor: Colors.transparent,
                            borderData: FlBorderData(show: false),
                            radarShape: RadarShape.polygon,
                            tickCount:
                                5, // Ensure at least 1 tick to avoid error
                            titlePositionPercentageOffset: 0.2,
                            tickBorderData: BorderSide(
                                color: Colors
                                    .black), // Make tick color transparent
                            gridBorderData: BorderSide(
                                color: Colors.transparent,
                                width: 1), // Keep circular grid lines black
                            radarBorderData:
                                BorderSide(color: Colors.black, width: 1),
                            ticksTextStyle:
                                TextStyle(color: Colors.transparent),
                            dataSets: [
                              RadarDataSet(
                                entryRadius: 3,
                                dataEntries: scores
                                    .map((score) => RadarEntry(
                                        value: double.parse(score.toString())))
                                    .toList(),
                                borderColor: mainblue,
                                fillColor: mainblue.withOpacity(0.4),
                                borderWidth: 2,
                              ),
                            ],
                            titleTextStyle:
                                TextStyle(fontSize: 12, color: Colors.black),
                            getTitle: (index, angle) {
                              const labels = [
                                'Speed',
                                'Strength',
                                'Agility',
                                'Endurance',
                                'Skill',
                                'Power'
                              ];
                              return RadarChartTitle(
                                text: "${labels[index]}\n${scores[index]}",
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  )
                ],
              )),
          SizedBox(height: 16),
          PhysicalAttributesSection(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Performance',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: deepBlueColor),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PhysicalAttributes(title: 'gools', value: 'x2'),
                    SizedBox(
                      width: 10,
                    ),
                    PhysicalAttributes(title: 'Assits', value: 'XIO'),
                    SizedBox(
                      width: 10,
                    ),
                    PhysicalAttributes(title: 'Rating', value: 'xl'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhysicalAttributes extends StatelessWidget {
  final String title;
  final String value;

  const PhysicalAttributes({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: superlightblue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          AutoSizeText(
            title,
            maxLines: 1,
            style: TextStyle(fontSize: 14, color: deepBlueColor),
          ),
          SizedBox(
            height: 10,
          ),
          AutoSizeText(
            value,
            maxLines: 1,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: deepBlueColor),
          ),
        ],
      ),
    ));
  }
}
