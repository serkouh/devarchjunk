import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageLoader extends StatefulWidget {
  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  String imageUrl = ''; // Store the image URL

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  // Fetch image URL from API
  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId =
        prefs.getString('user_id'); // Get the user_id from SharedPreferences

    if (userId != null) {
      final response = await http.get(
        Uri.parse('https://api.kickplayer.net/users/$userId/profile-cover'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final responseData = json.decode(response.body);
        setState(() {
          imageUrl = responseData['cover_image_url'] ?? ''; // Set the image URL
        });
      } else {
        // Handle the case when the API call fails
        print('Failed to load image: ${response.statusCode}');
      }
    } else {
      print('User ID not found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageUrl.isEmpty
        ? CircularProgressIndicator() // Show loading indicator while fetching data
        : Container(
            width:
                MediaQuery.of(context).size.width, // Ensures full screen width
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
              height: 175,
              width: MediaQuery.of(context).size.width,
            ),
          );
  }
}
