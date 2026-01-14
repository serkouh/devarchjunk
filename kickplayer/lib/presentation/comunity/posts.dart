import 'package:Kaledal/presentation/comunity/profile.dart';
import 'package:Kaledal/presentation/signup/Login.dart';
import 'package:Kaledal/presentation/widgets/customappbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:Kaledal/presentation/academy/dashbaord.dart';
import 'package:Kaledal/presentation/comunity/Profile_stats.dart';
import 'package:Kaledal/presentation/comunity/community.dart';
import 'package:Kaledal/presentation/comunity/createPost.dart';
import 'package:Kaledal/presentation/comunity/instaprofile.dart';
import 'package:Kaledal/presentation/home/navbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:Kaledal/presentation/profile/updateCaheiveent.dart';
import 'package:Kaledal/presentation/widgets/Profile_post.dart';
import 'package:Kaledal/presentation/widgets/fullname.dart';
import 'package:Kaledal/presentation/widgets/imageloader.dart';
import 'package:Kaledal/presentation/widgets/info_container.dart';
import 'package:Kaledal/presentation/widgets/posts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this for opening links

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    fetchProfileData();
    _fetchUserData();
    fetchPositionData();
    fetchAchievements();
    fetchpostsData();
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

  Map<String, dynamic>? postsData;

  Future<void> fetchpostsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    print('https://api.kickplayer.net/players/$userId/stats');
    try {
      final response = await http.get(
        Uri.parse('https://api.kickplayer.net/players/$userId/stats'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          postsData = json.decode(response.body);
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
      appBar: CustomAppBar(
        title: fullName ?? "...",
      ),
      /*  appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.transparent),
          onPressed: () {},
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 18, color: deepBlueColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete, // Changed icon to delete
              color: Colors.red,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: Text(
                      'Delete Account',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      'Are you sure you want to delete your account? This action cannot be undone.',
                      style: TextStyle(fontSize: 14),
                    ),
                    actions: [
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainblue,
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          final url =
                              Uri.parse("https://forms.gle/oLCP7txBCvAkzT949");
                          try {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("An error occurred: $e"),
                              ),
                            );
                          }
                        },
                        child: Text("Confirm"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: deepgrey,
            height: 1.0,
          ),
        ),
      ),*/
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section (Profile Picture and Header)
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Column(
                            children: [
                              ImageLoader(),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 125,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileStats()),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    ProfilePictureWidget(
                                      imageUrl: profileData?[
                                                  'profile_picture'] ==
                                              "string"
                                          ? 'https://cdn.britannica.com/69/228369-050-0B18A1F6/Asian-Cup-Final-2019-Hasan-Al-Haydos-Qatar-Japan-Takumi-Minamino.jpg'
                                          : profileData?['profile_picture'],
                                      borderColor: mainblue,
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              UserNameWithVerifiedIcon(),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InfoContainer(
                                      label: 'POSITION',
                                      value: (positionData?[0]
                                                  ['position_pos'] ??
                                              'Right Winger')
                                          .toString()),
                                  const SizedBox(width: 10),
                                  InfoContainer(
                                      label: 'AGE',
                                      value: calculateAge(
                                                  profileData?['birthday']
                                                          ?.toString() ??
                                                      "")
                                              .toString() ??
                                          '17'),
                                  const SizedBox(width: 10),
                                  InfoContainer(
                                      label: 'NATIONALITY',
                                      value: profileData?['nationality'] ??
                                          'Morocco'),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InfoContainer(
                                      label: 'Posts',
                                      value: (postsData?['post_count'] ?? '0')
                                          .toString()),
                                  SizedBox(width: 10),
                                  InfoContainer(
                                    label: 'Reactions',
                                    value: postsData?['total_reactions']
                                            ?.toString() ??
                                        "0",
                                  ),
                                  SizedBox(width: 10),
                                  InfoContainer(
                                    label: 'Media',
                                    value:
                                        postsData?['media_count'].toString() ??
                                            '0',
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

            // Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Info',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: deepBlueColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          /*  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreatePostPage()),
                          );*/
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => instaProfile()),
                          );
                        },
                        child: Icon(Icons.arrow_forward),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  PostProfile(
                    image: profileData?['profile_picture'] ?? "",
                    isHorizontal: true,
                  ),
                ],
              ),
            ),

            // Statistics Section
            RadarChartExample(),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Video introduction',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: deepBlueColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreatePostPage()),
                          );*/
                        },
                        child: Icon(Icons.edit),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue), // Blue border
                      borderRadius: BorderRadius.circular(12), // Border radius
                    ),
                    width: double.infinity,
                    height: 180,
                    child: VideoPlayerWidget(
                        profileData?["introduction_video"] ?? ""),
                  )
                ],
              ),
            ),
            SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Achievements',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: deepBlueColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AchievementUpdateScreen(
                                      onSuccess: fetchAchievements,
                                    )),
                          );
                        },
                        child: Icon(Icons.arrow_forward),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AchievementContainer(
                          title: 'League won',
                          value: data?.achievements[0].leaguesWon.toString() ??
                              ""),
                      SizedBox(
                        width: 10,
                      ),
                      AchievementContainer(
                          title: 'MVP',
                          value: data?.achievements[0].mvps.toString() ?? ""),
                      SizedBox(
                        width: 10,
                      ),
                      AchievementContainer(
                          title: 'Best Player',
                          value: data?.achievements[0].bestPlayer.toString() ??
                              ""),
                    ],
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  LogoutButton(
                    parentContext: context,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPost() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      //margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Profile and Follow Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(
                        "https://cdn.britannica.com/69/228369-050-0B18A1F6/Asian-Cup-Final-2019-Hasan-Al-Haydos-Qatar-Japan-Takumi-Minamino.jpg",
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Salim Alaoui",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "29 min • ",
                              style: TextStyle(
                                fontSize: 12,
                                color: deepgrey,
                              ),
                            ),
                            Text(
                              "Training & Drills",
                              style: TextStyle(
                                fontSize: 12,
                                color: mainblue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                /* GestureDetector(
                  onTap: () {
                    // Add your onTap action here
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8), // Adjust padding for height
                    decoration: BoxDecoration(
                      color: mainblue, // Blue background
                      borderRadius: BorderRadius.circular(8), // 8 Border radius
                    ),
                    child: Text(
                      "Follow",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white, // White text
                      ),
                    ),
                  ),
                )*/
              ],
            ),

            SizedBox(height: 10),

            /// Post Content
            Text(
              "What do you think?",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),

            SizedBox(height: 10),

            /// Post Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://cdn.britannica.com/69/228369-050-0B18A1F6/Asian-Cup-Final-2019-Hasan-Al-Haydos-Qatar-Japan-Takumi-Minamino.jpg",
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 10),

            /// Action Buttons
            Divider(color: Lightgrey),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAction(Icons.local_fire_department, "Helpful",
                      Colors.orange[600]!),
                  _buildAction(Icons.comment, "Comment", deepgrey),
                  _buildAction(Icons.share, "Share", deepgrey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Action Button Helper
  Widget _buildAction(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Statistics',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: deepBlueColor),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileStats()),
                  );
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: deepBlueColor,
                ),
              )
            ],
          ),
          SizedBox(height: 50),
          Container(
            height: 250,
            child: RadarChart(
              RadarChartData(
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                radarShape: RadarShape.polygon,
                tickCount: 5, // Ensure at least 1 tick to avoid error
                titlePositionPercentageOffset: 0.2,
                tickBorderData: BorderSide(
                    color: Colors.black), // Make tick color transparent
                gridBorderData: BorderSide(
                    color: Colors.transparent,
                    width: 1), // Keep circular grid lines black
                radarBorderData: BorderSide(color: Colors.black, width: 1),
                ticksTextStyle: TextStyle(color: Colors.transparent),
                dataSets: [
                  RadarDataSet(
                    entryRadius: 3,
                    dataEntries: scores
                        .map((score) =>
                            RadarEntry(value: double.parse(score.toString())))
                        .toList(),
                    borderColor: mainblue,
                    fillColor: mainblue.withOpacity(0.4),
                    borderWidth: 2,
                  ),
                ],
                titleTextStyle: TextStyle(fontSize: 12, color: Colors.black),
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
        ],
      ),
    );
  }
}

class AchievementContainer extends StatelessWidget {
  final String title;
  final String value;

  const AchievementContainer({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Lightgrey, width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            "x" + value,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: mainblue),
          ),
          AutoSizeText(
            title,
            maxLines: 1,
            style: TextStyle(fontSize: 12),
            minFontSize: 8, // Set the minimum font size
            maxFontSize: 12, // Set the maximum font size
            overflow: TextOverflow.ellipsis, // This will handle overflow
          )
        ],
      ),
    ));
  }
}

class Achievement {
  final int id;
  final int leaguesWon;
  final int mvps;
  final int bestPlayer;

  Achievement({
    required this.id,
    required this.leaguesWon,
    required this.mvps,
    required this.bestPlayer,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      leaguesWon: json['leagues_won'],
      mvps: json['mvps'],
      bestPlayer: json['best_player'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leagues_won': leaguesWon,
      'mvps': mvps,
      'best_player': bestPlayer,
    };
  }
}

class AchievementsResponse {
  final List<Achievement> achievements;

  AchievementsResponse({required this.achievements});

  factory AchievementsResponse.fromJson(Map<String, dynamic> json) {
    return AchievementsResponse(
      achievements: (json['achievements'] as List)
          .map((achievement) => Achievement.fromJson(achievement))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievements':
          achievements.map((achievement) => achievement.toJson()).toList(),
    };
  }
}

class LogoutButton extends StatelessWidget {
  final BuildContext parentContext;

  const LogoutButton({super.key, required this.parentContext});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data

    // Navigate to login screen and remove all previous routes
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () => _logout(parentContext),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
          side: const BorderSide(color: Colors.blue, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
        ),
        icon: const Icon(Icons.logout, color: Colors.blue),
        label: const Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blue,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
