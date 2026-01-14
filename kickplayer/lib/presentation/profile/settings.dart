import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/academy/acamdemy_homee.dart';
import 'package:Kaledal/presentation/profile/edit_profile.dart';
import 'package:Kaledal/presentation/profile/notif_setting.dart';
import 'package:Kaledal/presentation/profile/secutiry_option.dart';
import 'package:Kaledal/presentation/profile/social_accounts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Future<String?> fetchUserFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId != null) {
      final response = await http.get(
        Uri.parse('https://api.kickplayer.net/users/$userId'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['full_name'] ?? null;
      } else {
        print("Failed to fetch user: ${response.statusCode}");
      }
    } else {
      print("User ID not found in SharedPreferences");
    }

    return null;
  }

  Future<void> loadUserFullName() async {
    userFullName = await fetchUserFullName();
    print('User full name: $userFullName');
    setState(() {}); // if you're displaying it in a widget
  }

  String? userFullName;

  @override
  void initState() {
    super.initState();
    loadUserFullName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: deepBlueColor,
          ),
          onPressed: () {},
        ),
        title: Text(
          "Editing profile",
          style: TextStyle(fontSize: 18, color: deepBlueColor),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              // Handle search action
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Icon(
                Icons.search,
                color: mainblue,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Icon(
                Icons.more_vert,
                color: mainblue,
              ),
            ),
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
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xff0a4272),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                      "https://via.placeholder.com/150"), // Replace with real image
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userFullName ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    Text("ahmedali@gmail.com",
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildSectionTitle("Account Settings"),
                _buildTile(Icons.person_outline, "Personal Information",
                    context, PersonalInformationPage()),
                _buildTile(Icons.security_outlined, "Password & Security",
                    context, PasswordAndSecurityPage()),
                _buildTile(Icons.notifications_none,
                    "Notifications Preferences", context, NotificationsPage()),
                SizedBox(height: 24),
                _buildSectionTitle("Connected Account"),
                _buildTile(Icons.facebook, "Social Media Account", context,
                    LinkedAccountsPage()),
                _buildTile(Icons.account_balance_wallet_outlined,
                    "Connected Wallet", context, PersonalInformationPage()),
                SizedBox(height: 24),
                _buildSectionTitle("Contract Settings"),
                _buildTile(Icons.description_outlined, "Contract Information",
                    context, PersonalInformationPage()),
                _buildTile(Icons.public, "Clubs & Agents", context,
                    VirtualAcademyPage()),
                SizedBox(height: 24),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Sign Out", style: TextStyle(color: Colors.red)),
                  onTap: () {
                    // TODO: Handle sign out
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTile(
      IconData icon, String title, BuildContext context, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 16),
            Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
            color: deepgrey, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}
