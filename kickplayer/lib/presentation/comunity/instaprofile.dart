import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:Kaledal/presentation/profile/settings.dart';
import 'package:Kaledal/presentation/widgets/Profile_post.dart';
import 'package:Kaledal/presentation/widgets/VideoGrid.dart';
import 'package:Kaledal/presentation/widgets/fullname.dart';
import 'package:Kaledal/presentation/widgets/image_grid.dart';
import 'package:Kaledal/presentation/widgets/imageloader.dart';
import 'package:Kaledal/presentation/widgets/info_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class instaProfile extends StatefulWidget {
  @override
  _instaProfileState createState() => _instaProfileState();
}

class _instaProfileState extends State<instaProfile> {
  int _selectedTabIndex = 0;
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  String userId = "";
  @override
  void initState() {
    super.initState();
    fetchProfileData();
    fetchPositionData();
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
        _tabContent = [
          PostProfile(
            image: profileData?['profile_picture'] ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqafzhnwwYzuOTjTlaYMeQ7hxQLy_Wq8dnQg&s',
            isHorizontal: false,
          ),
          ImageGridView(),
          VideoGridView(),
        ];
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load profile data');
    }
  }

  Map<String, dynamic>? positionData;

  Future<void> fetchPositionData() async {
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

  // Content for each tab
  List<Widget> _tabContent = [];
  @override
  Widget build(BuildContext context) {
    return /*SafeArea(
        child:*/
        Scaffold(
            backgroundColor: Colors.white,
            body: MediaQuery.removePadding(
                context: context,
                //removeTop: true,
                child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          backgroundColor: Colors.white,
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back, color: deepBlueColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                          title: Text(
                            "Profile",
                            style:
                                TextStyle(fontSize: 18, color: deepBlueColor),
                          ),
                          centerTitle: true,
                          actions: [
                            IconButton(
                              icon: Icon(Icons.ios_share, color: mainblue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfilePage()),
                                );
                              },
                            ),
                          ],
                          elevation: 0,
                          pinned: true,
                          expandedHeight: 0,
                          floating: false,
                          forceElevated: innerBoxIsScrolled,
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(1.0),
                            child: Container(color: deepgrey, height: 1.0),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Section
                              Container(
                                height: 350,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                width: 104,
                                                height: 104,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: mainblue,
                                                      width: 4),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: NetworkImage(
                                                    profileData?[
                                                            'profile_picture'] ??
                                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqafzhnwwYzuOTjTlaYMeQ7hxQLy_Wq8dnQg&s',
                                                  ),
                                                ),
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
                                                        color: Colors.white,
                                                        width: 2),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          UserNameWithVerifiedIcon(),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InfoContainer(
                                                  label: 'Posts',
                                                  value: (positionData?[
                                                              'post_count'] ??
                                                          '0')
                                                      .toString()),
                                              SizedBox(width: 10),
                                              InfoContainer(
                                                label: 'Reactions',
                                                value: positionData?[
                                                            'total_reactions']
                                                        ?.toString() ??
                                                    "0",
                                              ),
                                              SizedBox(width: 10),
                                              InfoContainer(
                                                label: 'Media',
                                                value:
                                                    positionData?['media_count']
                                                            .toString() ??
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
                              // Tabs Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(width: 16),
                                  Expanded(child: _buildTab('Feed', 0)),
                                  SizedBox(width: 16),
                                  Expanded(child: _buildTab('Images', 1)),
                                  SizedBox(width: 16),
                                  Expanded(child: _buildTab('Videos', 2)),
                                  SizedBox(width: 16),
                                ],
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        )
                      ];
                    },
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _tabContent[_selectedTabIndex],
                      //  ),
                    ))));
  }

  // Create the clickable tab container
  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index; // Update the selected tab index
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: _selectedTabIndex == index
              ? mainblue
              : Colors.white, // Change color on selection
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: mainblue),
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _selectedTabIndex == index ? Colors.white : mainblue,
          ),
        )),
      ),
    );
  }

  // Helper method for displaying the profile info
}

class PostTabWidget extends StatelessWidget {
  // This method builds the post widgets for each tab
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildNewPost(),
        _buildNewPost(),
        _buildNewPost(),
      ],
    );
  }

  // The method to build a single new post widget
  Widget _buildNewPost() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile and Follow Button
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
              ],
            ),

            SizedBox(height: 10),

            // Post Content
            Text(
              "What do you think?",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),

            SizedBox(height: 10),

            // Post Image
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

            // Action Buttons
            Divider(color: Colors.grey[300]),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAction(Icons.local_fire_department, "Helpful",
                      Colors.orange[600]!),
                  _buildAction(Icons.comment, "Comment", Colors.grey[700]!),
                  _buildAction(Icons.share, "Share", Colors.grey[700]!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Button Helper
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
