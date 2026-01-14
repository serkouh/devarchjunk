import 'package:Kaledal/presentation/home/record_challenge.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/Models/community.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/core/ulitlites/date_converter.dart';
import 'package:Kaledal/presentation/comunity/post_details.dart';
import 'package:video_player/video_player.dart';

class PostWithComments extends StatefulWidget {
  @override
  _PostWithCommentsState createState() => _PostWithCommentsState();
}

class _PostWithCommentsState extends State<PostWithComments> {
  /// Fetches posts from the API (using the "new_posts" list).
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('https://api.kickplayer.net/community/feed'),
      headers: {'accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['new_posts']);

      List postsJson = data['new_posts'];
      return postsJson.map((json) => Post.fromJson(json)).toList();
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
      print("////////////////");
      print(data['comments']);
      List commentsJson = data['comments'];
      return List<Map<String, dynamic>>.from(commentsJson);
    } else {
      throw Exception('Failed to load comments');
    }
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
                  child: Center(child: CircularProgressIndicator()));
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
                      final author = comment['author'] ?? {};
                      final profilePic = author['profile_picture'] ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqafzhnwwYzuOTjTlaYMeQ7hxQLy_Wq8dnQg&s';
                      final authorName = author['name'] ?? 'Unknown';
                      final createdAt = comment['created_at'] ?? '';
                      final content = comment['content'] ?? '';
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
                                    authorName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    createdAt?.toString().substring(0, 10) ??
                                        '',
                                    style: TextStyle(
                                        fontSize: 12, color: deepgrey),
                                  ),
                                  SizedBox(height: 5),
                                  Text(content ?? ''),
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
    return FutureBuilder<List<Post>>(
      future: fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          List<Post> posts = snapshot.data!;
          return Column(
            children: posts
                .map(
                  (post) => PostSection(
                    thumbnail:
                        post.thumbnails.isNotEmpty ? post.thumbnails.first : "",
                    topic_name: post.topicName,
                    postId: post.id,
                    avatarUrl: post
                        .author_profile_picture, // Replace with dynamic URL if available.
                    userName: post.authorName,
                    postTime: post.createdAt,
                    postText: post.content,
                    postMediaUrl:
                        post.mediaUrls.isNotEmpty ? post.mediaUrls.first : "",
                    onViewComments: _showComments,
                  ),
                )
                .toList(),
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
  final String thumbnail;
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
    required this.thumbnail,
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
                ],
              ),
              SizedBox(height: 10),
              Text(postText),
              SizedBox(height: 10),

              // Check if the media URL is empty, image, or video
              if (postMediaUrl.isNotEmpty || thumbnail.isNotEmpty)
                _buildMedia(thumbnail.isNotEmpty
                    ? thumbnail
                    : postMediaUrl), // Only show media if the URL is not empty

              SizedBox(height: 10),
              Divider(color: Lightgrey),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReactionButton(
                      icon: Icons.local_fire_department,
                      label: "Helpful",
                      postId: postId,
                    ),
                    _buildAction(Icons.comment, "Comment", deepgrey),
                    _buildAction(Icons.share, "Share", deepgrey),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  // Method to handle the media (image or video)
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
            /*  Container(
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
      );
    } else {
      return Container(); // Empty container if unsupported media
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

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget(this.videoUrl, {Key? key}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _isPlaying = _controller.value.isPlaying;
        });
      }).catchError((error) {
        setState(() {
          _isInitialized = false;
        });
        print("Error initializing video player: $error");
      });

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 180, // 👈 Limit height
                  ),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FullScreenVideo(controller: _controller!),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!),
                            ),
                          ),
                        ),
                        /*  if (!_isPlaying)
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            color: Colors.black45,
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 64,
                            ),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            color: Colors.transparent,
                          ),
                        )*/
                      ],
                    ),
                  ),
                ),
                /*  VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_controller.value.position),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.blueAccent,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                  Text(
                    _formatDuration(_controller.value.duration),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],*/
              )
            ],
          )
        : Center(child: CircularProgressIndicator());
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  String _formatDuration(Duration duration) {
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
