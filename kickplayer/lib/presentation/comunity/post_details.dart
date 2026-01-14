import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/core/ulitlites/date_converter.dart';
import 'package:Kaledal/presentation/widgets/VideoGrid.dart';
import 'package:Kaledal/presentation/widgets/posts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostWithCommentsPage extends StatefulWidget {
  final int postId;
  final String avatarUrl;
  final String userName;
  final String postTime;
  final String postText;
  final String postMediaUrl;
  final String Topic;

  const PostWithCommentsPage({
    Key? key,
    required this.postId,
    required this.avatarUrl,
    required this.userName,
    required this.postTime,
    required this.postText,
    required this.postMediaUrl,
    required this.Topic,
  }) : super(key: key);

  @override
  _PostWithCommentsPageState createState() => _PostWithCommentsPageState();
}

class _PostWithCommentsPageState extends State<PostWithCommentsPage> {
  TextEditingController _messageController = TextEditingController();
  bool isLoading = false;
  Future<void> sendComment({
    required String content,
    required int postId,
    required int topicId,
  }) async {
    // Check if content is empty
    if (content.isEmpty) {
      print('Content cannot be empty');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    final Uri url = Uri.parse(
        'https://api.kickplayer.net/community/posts/$postId/comments/$userId');

    // Debug: Print out the URL and the data being sent
    print('Sending comment to: $url');
    print('Content: $content');

    try {
      var response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          // Uncomment this if your API requires auth token
          // 'Authorization': 'Bearer $authToken',
          'Content-Type':
              'application/x-www-form-urlencoded', // Correct content type
        },
        body: {
          'content': content, // Correctly pass content as form data
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        print('Comment sent successfully!');
      } else {
        print('Failed to send comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending comment: $e');
    }
    setState(() {});
  }

  bool _liked = false;
  bool _isReacting = false;

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
          widget.userName + " posts",
          style: TextStyle(fontSize: 18, color: deepBlueColor),
        ),
        centerTitle: true,
        actions: [
          /* GestureDetector(
            onTap: () {
              // Handle more options action
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Icon(
                Icons.more_vert,
                color: mainblue,
              ),
            ),
          ),*/
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
      body: ListView(
        // Use ListView for scrolling content
        children: [
          Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Lightgrey, width: 0.5),
                  left: BorderSide(color: Lightgrey, width: 0.5),
                  right: BorderSide(color: Lightgrey, width: 0.5),
                  bottom: BorderSide.none,
                ),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(widget.avatarUrl),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                            Row(
                              children: [
                                Text("${getTimeAgo(widget.postTime)} • ",
                                    style: TextStyle(
                                        fontSize: 12, color: deepgrey)),
                                Text(widget.Topic,
                                    style: TextStyle(
                                        fontSize: 12, color: mainblue)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(widget.postText),
                    SizedBox(height: 10),
                    if (widget.postMediaUrl.isNotEmpty)
                      _buildMedia(context, widget.postMediaUrl),
                    Divider(color: Lightgrey),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReactionButton(
                            icon: Icons.local_fire_department,
                            label: "Helpful",
                            postId: widget.postId,
                          ),
                          _buildAction(Icons.comment, "Comment", deepgrey),
                          _buildAction(Icons.share, "Share", deepgrey),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: EdgeInsets.all(0), // margin set to 16
                      decoration: BoxDecoration(
                        color: superlightblue,
                        borderRadius:
                            BorderRadius.circular(8), // Added border radius
                      ),
                      constraints: BoxConstraints(
                        minHeight: 200, // Minimum height set to 300
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "All Comments",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: fetchComments(widget.postId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error: ${snapshot.error}"));
                              } else if (snapshot.hasData ||
                                  snapshot.data != null ||
                                  snapshot.data!.isNotEmpty) {
                                final comments = snapshot.data!;
                                if (comments.isEmpty) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Text("No comments yet"),
                                    ],
                                  );
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: comments.length,
                                    itemBuilder: (context, index) {
                                      final comment = comments[index];
                                      final author = comment['author'] ?? {};
                                      final profilePic = author[
                                              'profile_picture'] ??
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqafzhnwwYzuOTjTlaYMeQ7hxQLy_Wq8dnQg&s';
                                      final authorName =
                                          author['name'] ?? 'Unknown';
                                      final createdAt =
                                          comment['created_at'] ?? '';
                                      final content = comment['content'] ?? '';

                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            profilePic),
                                                    radius: 20,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                            0xFFF1F7FB), // light blue-ish background
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                authorName,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 8),
                                                            ],
                                                          ),
                                                          Text(
                                                            getTimeAgo(
                                                                createdAt),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start, // Aligns buttons to the end
                                                  children: [
                                                    Text(
                                                      content,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                      textAlign: TextAlign
                                                          .start, // Centers the text itself
                                                    )
                                                  ]),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end, // Aligns buttons to the end
                                                children: [
                                                  Text(
                                                    "Like",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  Text(
                                                    "Reply",
                                                    style: TextStyle(
                                                      color: deepBlueColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ));
                                    },
                                  );
                                }
                              } else {
                                return Center(
                                    child: Text("No comments available"));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: "Write your comment ",
                                  hintStyle: TextStyle(
                                      color: deepgrey,
                                      fontSize: 12), // Smaller hint text
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        4), // Thinner border radius
                                    borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade200, // Dark black border color
                                      width: 1, // Thinner border width
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        4), // Thinner border radius
                                    borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade200, // Dark black border color
                                      width: 1, // Thinner border width
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        4), // Thinner border radius
                                    borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade200, // Dark black border color
                                      width: 1, // Thinner border width
                                    ),
                                  ),
                                ),
                              )),
                              isLoading
                                  ? CircularProgressIndicator() // Show loading indicator
                                  : IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () async {
                                        if (!isLoading) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          String commentText =
                                              _messageController.text.trim();
                                          if (commentText.isNotEmpty) {
                                            // Send the comment
                                            await sendComment(
                                                content: commentText,
                                                postId: widget.postId,
                                                topicId: 1);
                                          }
                                          _messageController.clear();
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      },
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]))
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle the action
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

  Future<List<Map<String, dynamic>>> fetchComments(int postId) async {
    final response = await http.get(
      Uri.parse('https://api.kickplayer.net/community/posts/$postId/full'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("////////////////");
      print(data['comments']);
      List commentsJson = data['comments'];
      return List<Map<String, dynamic>>.from(commentsJson);
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Widget _buildMedia(BuildContext context, String mediaUrl) {
    if (_isImageUrl(mediaUrl)) {
      return GestureDetector(
        onTap: () {
          handleMediaClick(context, mediaUrl);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            mediaUrl,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (_isVideoUrl(mediaUrl)) {
      return GestureDetector(
        onTap: () {
          handleMediaClick(context, mediaUrl);
        },
        child: Container(
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
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),*/
            ],
          ),
        ),
      );
    } else {
      return Container(); // Fallback for unsupported media
    }
  }

  bool _isImageUrl(String url) {
    return url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.gif') ||
        url.toLowerCase().endsWith('.bmp');
  }

  bool _isVideoUrl(String url) {
    return url.toLowerCase().endsWith('.mp4') ||
        url.toLowerCase().endsWith('.avi') ||
        url.toLowerCase().endsWith('.mov') ||
        url.toLowerCase().endsWith('.mkv');
  }

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

  void handleMediaClick(BuildContext context, String url) {
    if (_isImageUrl(url)) {
      _showImageDialog(context, url);
    } else if (_isVideoUrl(url)) {
      showDialog(
        context: context,
        barrierColor: Colors.grey.withOpacity(0.4), // Semi-transparent grey
        builder: (_) {
          final screenSize = MediaQuery.of(context).size;
          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), // Blur effect
                child: Container(color: Colors.transparent),
              ),
              Center(
                child: SizedBox(
                  width: screenSize.width, // Full screen width
                  height: screenSize.height * 0.4, // 40% of screen height
                  child: Dialog(
                    insetPadding: EdgeInsets.zero,
                    backgroundColor: Colors.white, // White dialog background
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Smaller border radius
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          // The video player content
                          VideoPlayerDialog(videoUrl: url),

                          // The close icon button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.close,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unsupported media format')),
      );
    }
  }
}

class ReactionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final int postId;

  const ReactionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.postId,
  }) : super(key: key);

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  bool _liked = false;
  bool _isReacting = false;

  Future<void> _toggleLike() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    if (_isReacting) return; // Prevent spamming

    setState(() {
      _isReacting = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://api.kickplayer.net/community/posts/${widget.postId}/reactions/$userId'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'reaction_type': 'like'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _liked = !_liked; // Toggle reaction state
        });
      } else {
        print("Failed to react: ${response.statusCode}");
      }
    } catch (e) {
      print("Error reacting: $e");
    } finally {
      setState(() {
        _isReacting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color reactionColor = _liked ? Colors.orange : deepgrey;

    return GestureDetector(
      onTap: _toggleLike,
      child: Row(
        children: [
          Icon(widget.icon, color: reactionColor, size: 18),
          SizedBox(width: 5),
          Text(
            widget.label,
            style: TextStyle(fontSize: 12, color: reactionColor),
          ),
        ],
      ),
    );
  }
}
