import 'package:flutter/material.dart';
import 'package:Kaledal/Models/community.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/core/ulitlites/date_converter.dart';
import 'package:Kaledal/presentation/comunity/post_details.dart';
import 'package:Kaledal/presentation/widgets/posts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostProfile extends StatefulWidget {
  final bool isHorizontal;
  final String image;

  const PostProfile({Key? key, required this.isHorizontal, required this.image})
      : super(key: key);

  @override
  _PostProfileState createState() => _PostProfileState();
}

class _PostProfileState extends State<PostProfile> {
  List postsJson = [];
  Future<void> loadUserFullName() async {
    userFullName = await fetchUserFullName();
    print('User full name: $userFullName');
    setState(() {}); // if you're displaying it in a widget
  }

  String? userFullName;
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

  Future<List<PostProfileList>> fetchPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    final response = await http.get(
      Uri.parse('https://api.kickplayer.net/users/$userId/posts'),
      headers: {'accept': 'application/json'},
    );
    print("**********************");
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      postsJson = data['posts'];
      return postsJson.map((json) => PostProfileList.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  /// Fetches comments for a specific post from the API.
  Future<List<Map<String, dynamic>>> fetchComments(int postId) async {
    final response = await http.get(
      Uri.parse('https://api.kickplayer.net/community/posts/$postId/full'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List commentsJson = data['comments'];
      return List<Map<String, dynamic>>.from(commentsJson);
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserFullName();
  }

  /// Displays the comments modal for a given postId.
  void _showComments(int postId) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchComments(postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Container(
                height: 300,
                child: Center(child: Text("Error: ${snapshot.error}")),
              );
            } else if (snapshot.hasData) {
              final comments = snapshot.data!;
              if (comments.isEmpty) {
                return Container(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.comment, size: 50, color: deepgrey),
                        SizedBox(height: 10),
                        Text(
                          "No comments yet",
                          style: TextStyle(fontSize: 16, color: deepgrey),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  height: 300,
                  padding: EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(comment['avatar'] ??
                                  'https://via.placeholder.com/150'),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment['name'] ?? 'Unknown',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    comment['time']
                                            ?.toString()
                                            .substring(0, 10) ??
                                        '',
                                    style: TextStyle(
                                        fontSize: 12, color: deepgrey),
                                  ),
                                  SizedBox(height: 5),
                                  Text(comment['text'] ?? ''),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            } else {
              return Container(
                height: 300,
                child: Center(child: Text("No comments available")),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostProfileList>>(
      future: fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          List<PostProfileList> posts = snapshot.data!;

          // 🛠️ Filter posts if isHorizontal is true
          if (widget.isHorizontal) {
            posts = posts.where((post) => post.mediaUrls.isNotEmpty).toList();
          }

          return SizedBox(
            height: widget.isHorizontal ? 300 : null,
            child: ListView.builder(
              scrollDirection:
                  widget.isHorizontal ? Axis.horizontal : Axis.vertical,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                PostProfileList post = posts[index];
                return Container(
                  width: widget.isHorizontal
                      ? MediaQuery.of(context).size.width * 0.9
                      : null,
                  margin: EdgeInsets.symmetric(
                    horizontal: widget.isHorizontal ? 8 : 0,
                    vertical: widget.isHorizontal ? 0 : 8,
                  ),
                  child: PostSection(
                    topic_name: post.topic_name,
                    postId: post.id,
                    avatarUrl: widget.image,
                    userName: userFullName ?? "",
                    postTime: post.createdAt.toString().substring(0, 10),
                    postText: post.content,
                    postMediaUrl:
                        post.mediaUrls.isNotEmpty ? post.mediaUrls.first : "",
                    onViewComments: _showComments,
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: Text("No posts available"));
        }
      },
    );
  }
}

class PostSection extends StatelessWidget {
  final int postId;
  final String avatarUrl;
  final String userName;
  final String postTime;
  final String postText;
  final String topic_name;
  final String postMediaUrl; // General media URL (either image or video)
  final Function(int) onViewComments;

  const PostSection({
    Key? key,
    required this.postId,
    required this.avatarUrl,
    required this.userName,
    required this.postTime,
    required this.postText,
    required this.topic_name,
    required this.postMediaUrl, // Using a single field for both image and video
    required this.onViewComments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostWithCommentsPage(
                Topic: topic_name,
                postId: postId,
                avatarUrl: avatarUrl,
                userName: userName,
                postTime: postTime,
                postText: postText,
                postMediaUrl: postMediaUrl, // Pass the media URL here
              ),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Lightgrey, width: 0.5),
          ),
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
                        backgroundImage: NetworkImage(avatarUrl),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${getTimeAgo(postTime)} • ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: deepgrey,
                                ),
                              ),
                              Text(
                                topic_name,
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
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Drag handle
                                Container(
                                  height: 4,
                                  width: 40,
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),

                                // Edit Option
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Handle edit
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.black),
                                        SizedBox(width: 12),
                                        Text(
                                          "Edit",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Delete Option (in red)
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Handle delete
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 12),
                                        Text(
                                          "Delete",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Unpublish Option
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Handle unpublish
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Row(
                                      children: [
                                        Icon(Icons.visibility_off,
                                            color: Colors.black),
                                        SizedBox(width: 12),
                                        Text(
                                          "Unpublish",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(Icons.more_vert, color: Colors.grey[800]),
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(postText),
              SizedBox(height: 10),

              // Check if the media URL is empty, image, or video
              if (postMediaUrl.isNotEmpty) _buildMedia(postMediaUrl),

              SizedBox(height: 10),
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
        ));
  }

  Widget _buildMedia(String mediaUrl) {
    if (_isImageUrl(mediaUrl)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          mediaUrl,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        ),
      );
    } else if (_isVideoUrl(mediaUrl)) {
      return Container(
        width: double.infinity,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: VideoPlayerWidget(mediaUrl),
            ),
            /* Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 48,
              ),
            ),*/
          ],
        ),
      );
    } else {
      return Container(); // Empty container if the URL is not an image or video
    }
  }

  // Check if the URL is an image
  bool _isImageUrl(String url) {
    return url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.gif') ||
        url.toLowerCase().endsWith('.bmp');
  }

  // Check if the URL is a video
  bool _isVideoUrl(String url) {
    return url.toLowerCase().endsWith('.mp4') ||
        url.toLowerCase().endsWith('.avi') ||
        url.toLowerCase().endsWith('.mov') ||
        url.toLowerCase().endsWith('.mkv');
  }

  Widget _buildAction(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        // Pass the postId when calling onViewComments.
        onViewComments(postId);
      },
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }
}

class PostProfileList {
  final int id;
  final String content;
  final String topic_name;
  final List<String> mediaUrls;
  final List<String> thumbnails;
  final DateTime createdAt;
  final int reactionCount;
  final int topicId;
  final int userId;
  final int commentCount;

  PostProfileList({
    required this.id,
    required this.content,
    required this.topic_name,
    required this.mediaUrls,
    required this.thumbnails,
    required this.createdAt,
    required this.reactionCount,
    required this.topicId,
    required this.userId,
    required this.commentCount,
  });

  factory PostProfileList.fromJson(Map<String, dynamic> json) {
    List<String> mediaUrls = [];
    List<String> thumbnails = [];

    if (json['media_urls'] is Map) {
      var mediaUrlsObj = json['media_urls'] as Map<String, dynamic>;
      mediaUrls = List<String>.from(mediaUrlsObj['urls'] ?? []);
      thumbnails = List<String>.from(mediaUrlsObj['thumbnails'] ?? []);

      // Fill the shorter list to match the other
      if (mediaUrls.length > thumbnails.length) {
        thumbnails = List.generate(mediaUrls.length, (index) => '');
      } else if (thumbnails.length > mediaUrls.length) {
        mediaUrls = List.generate(thumbnails.length, (index) => '');
      }
    } else if (json['media_urls'] is List) {
      mediaUrls = List<String>.from(json['media_urls']);
      thumbnails = List.generate(mediaUrls.length, (index) => '');
    } else {
      throw Exception('Invalid media_urls format');
    }

    return PostProfileList(
      id: json['id'],
      content: json['content'],
      topic_name: json['topic_name'],
      mediaUrls: mediaUrls,
      thumbnails: thumbnails,
      createdAt: DateTime.parse(json['created_at']),
      reactionCount: json['reaction_count'],
      topicId: json['topic_id'],
      userId: json['user_id'],
      commentCount: json['comment_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'topic_name': topic_name,
      'media_urls': {
        'urls': mediaUrls,
        'thumbnails': thumbnails,
      },
      'created_at': createdAt.toIso8601String(),
      'reaction_count': reactionCount,
      'topic_id': topicId,
      'user_id': userId,
      'comment_count': commentCount,
    };
  }
}
