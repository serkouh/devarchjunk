import 'package:Kaledal/presentation/chats/allchat.dart';
import 'package:Kaledal/presentation/comunity/post_details.dart';
import 'package:Kaledal/presentation/home/navbar.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/Models/community.dart';
import 'package:Kaledal/Models/pinned_toppics.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Kaledal/presentation/comunity/all_posts.dart';

class NutritionGuidesPage extends StatefulWidget {
  final String id;
  final String title;

  // Constructor to accept two string parameters
  const NutritionGuidesPage({Key? key, required this.title, required this.id})
      : super(key: key);

  @override
  State<NutritionGuidesPage> createState() => _NutritionGuidesPageState();
}

class _NutritionGuidesPageState extends State<NutritionGuidesPage> {
  late Future<Map<String, dynamic>> topicDetails;

  @override
  void initState() {
    super.initState();
    topicDetails = fetchTopicDetails();
  }

  List<PostPined> posts = [];
  List<Topicpined> suggestedTopics = [];
  Future<Map<String, dynamic>> fetchTopicDetails() async {
    final response = await http.get(
      Uri.parse(
          'https://api.kickplayer.net/community/topics/${widget.id}/details'),
      headers: {"accept": "application/json"},
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        posts = (data['latest_posts'] as List)
            .map((item) => PostPined.fromJson(item))
            .toList();
        print("|+++++++++++++++++++++++++++++++++++++++++");
        print(data['latest_posts']);
        suggestedTopics = (data['suggested_topics'] as List)
            .map((item) => Topicpined.fromJson(item))
            .toList();
      });

      return {
        'posts': posts,
        'suggestedTopics': suggestedTopics,
      };
    } else {
      throw Exception('Failed to load topic details');
    }
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 18, color: deepBlueColor),
        ),
        centerTitle: true,
        actions: [
          /*GestureDetector(
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
          ),*/
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
        /*  bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: deepgrey,
            height: 1.0,
          ),
        ),*/
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // People online
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('People (231 online)',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('View all',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500))
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 85,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var name in [
                      'Ahmed',
                      'Ali',
                      'Yusuf',
                      'Rami',
                      'hassan'
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage('assets/user.png')),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                      radius: 5, backgroundColor: Colors.green),
                                )
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(name,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600))
                          ],
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Latest Discussions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Latest Discussions',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => onlyposts(
                                  title: "All Discussions",
                                )),
                      );
                    },
                    child: Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 185,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(posts.length, (index) {
                    return GestureDetector(
                        onTap: () {
                          PostPined post = posts[index];
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => onlyposts(
                                      title: posts[index].content,
                                    )),
                          );*/
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostWithCommentsPage(
                                postId: post.id,
                                avatarUrl: post.userProfilePicture,
                                userName: post.userName,
                                postTime: post.createdAt,
                                postText: post.content,
                                postMediaUrl: post.mediaUrls.isNotEmpty
                                    ? post.mediaUrls[0]
                                    : '',
                                Topic:
                                    '', // You can pass a topic if you have one, otherwise leave it empty
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 12, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 5,
                                  offset: Offset(0, 2)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: posts[index].mediaUrls.isNotEmpty
                                    ? Image.network(
                                        posts[index].mediaUrls[0],
                                        height: 100,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 100,
                                        width: 200,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.image_not_supported,
                                            color: Colors.grey[700]),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(posts[index].content,
                                        style: TextStyle(
                                            color: deepBlueColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12)),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.comment,
                                            size: 14, color: Colors.blue),
                                        SizedBox(width: 4),
                                        Text(7.toString(),
                                            style: TextStyle(
                                                color: mainblue, fontSize: 12))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  }),
                ),
              ),
              SizedBox(height: 32),

              // Trendy Communities
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trendy Communities',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(initialIndex: 1),
                        ),
                      );
                    },
                    child: Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: suggestedTopics.map((topic) {
                    return buildCommunityCard(
                        topic.name,
                        topic.postCount.toString(),
                        "78",
                        topic.imageFromPost,
                        topic.id);
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCommunityCard(String title, String members, String discussions,
      String imagePath, int id) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NutritionGuidesPage(
                      id: id.toString(),
                      title: title,
                    )),
          );
        },
        child: Container(
          width: 180,
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  width: 180,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        mainblue,
                        deepBlueColor
                      ], // light blue to dark blue
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.forum,
                              size: 12,
                              color: Colors.white), // You can change icon
                          SizedBox(width: 4),
                          Text(
                            discussions,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: mainblue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('Join',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              )
            ],
          ),
        ));
  }
}
