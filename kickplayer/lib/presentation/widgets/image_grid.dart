import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Kaledal/core/theme_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageGridView extends StatefulWidget {
  @override
  _ImageGridViewState createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  List<String> imageUrls = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  /// Fetches images from API
  Future<void> fetchImages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final response = await http.get(
        Uri.parse(
            'https://api.kickplayer.net/users/$userId/photos'), // Change to your API URL
        headers: {'accept': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        final data = json.decode(response.body);
        setState(() {
          imageUrls =
              List<String>.from(data['photos'].map((photo) => photo['url']));
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load images';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : errorMessage.isNotEmpty
              ? Center(
                  child:
                      Text(errorMessage, style: TextStyle(color: Colors.red)))
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3, // 3 images per row
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () =>
                            _showImageDialog(context, imageUrls[index]),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                12), // Added border radius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // Ensures image has the same border radius
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image,
                                      size: 50, color: deepgrey),
                            ),
                          ),
                        ));
                  },
                ),
    );
  }

  // Method to show image in a dialog
  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }
}
