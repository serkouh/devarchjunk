import 'package:Kaledal/presentation/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/Models/community.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/core/ulitlites/date_converter.dart';
import 'package:Kaledal/presentation/comunity/createPost.dart';
import 'package:Kaledal/presentation/comunity/pinned_toppics.dart';
import 'package:Kaledal/presentation/comunity/post_details.dart';
import 'package:Kaledal/presentation/comunity/trendyswips.dart';
import 'package:Kaledal/presentation/home/navbar.dart';
import 'package:Kaledal/presentation/widgets/posts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late FeedResponse feedResponse;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    // Fetch the data on widget initialization
    fetchFeed();
  }

  // Fetch the feed data
  Future<void> fetchFeed() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.kickplayer.net/community/feed'),
        headers: {'accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          feedResponse = FeedResponse.fromJson(data);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load feed');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePostPage()),
            );
          },
          backgroundColor: mainblue, // Optional: Customize color
          child: Icon(Icons.add, color: Colors.white), // The "+" icon
        ),
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Community",
        ),
        body: isLoading
            ? Center(
                child:
                    CircularProgressIndicator()) // Show loading indicator while fetching data
            : hasError
                ? Center(
                    child: Text(
                        'Error loading feed')) // Show error message if API call fails
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pinned Topics Section
                          Row(
                            children: [
                              Icon(Icons.push_pin,
                                  color: deepBlueColor, size: 20),
                              SizedBox(width: 5),
                              Text(
                                "Pinned Topics",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: deepBlueColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: feedResponse.pinnedTopics
                                  .map((topic) => _buildPinnedTopic(topic))
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 24),
                          // Trendy Discussions Section (Trending Posts)
                          Row(
                            children: [
                              Text(
                                "Trendy Discussions",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: deepBlueColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          AutoScrollTrendingPosts(
                              posts: feedResponse.trendingPosts),
                          SizedBox(height: 16),
                          // New Posts Section
                          Text(
                            "New Posts",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: deepBlueColor,
                            ),
                          ),
                          SizedBox(height: 10),
                          PostWithComments(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildPinnedTopic(PinnedTopic topic) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NutritionGuidesPage(
                      id: topic.id.toString(),
                      title: topic.name,
                    )),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            children: [
              Stack(
                clipBehavior:
                    Clip.none, // Allows the bubble to be outside the avatar
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(topic.image_url),
                  ),
                  Positioned(
                    top: -2, // Adjust positioning
                    right: -2,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 197, 119, 1),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white,
                            width: 2), // White border for better visibility
                      ),
                      child: Text(
                        "4", // Number inside the bubble
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(topic.name,
                  style: TextStyle(fontSize: 12, color: deepBlueColor)),
            ],
          ),
        ));
  }
}
