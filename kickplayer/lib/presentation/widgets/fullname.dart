import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserNameWithVerifiedIcon extends StatefulWidget {
  const UserNameWithVerifiedIcon({super.key});

  @override
  _UserNameWithVerifiedIconState createState() =>
      _UserNameWithVerifiedIconState();
}

class _UserNameWithVerifiedIconState extends State<UserNameWithVerifiedIcon> {
  String? fullName;
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

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
  Widget build(BuildContext context) {
    if (fullName == null) {
      return const CircularProgressIndicator();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          fullName!,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFF002F6C), // Replace with deepBlueColor if defined
          ),
        ),
        const SizedBox(width: 5),
        if (isVerified)
          const Icon(
            Icons.verified,
            color: Color(0xFF2066C0), // Replace with mainblue if defined
            size: 20,
          ),
      ],
    );
  }
}
