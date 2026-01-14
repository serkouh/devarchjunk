import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Kaledal/Models/community.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/comunity/post_details.dart';

class AutoScrollTrendingPosts extends StatefulWidget {
  final List<Post> posts;

  const AutoScrollTrendingPosts({Key? key, required this.posts})
      : super(key: key);

  @override
  _AutoScrollTrendingPostsState createState() =>
      _AutoScrollTrendingPostsState();
}

class _AutoScrollTrendingPostsState extends State<AutoScrollTrendingPosts> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  int _currentIndex = 0;
  double? _screenWidth;

  @override
  void initState() {
    super.initState();

    // Capture screen width after the first layout pass
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
      });
    });

    // Start the auto-scroll timer
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_scrollController.hasClients &&
          widget.posts.isNotEmpty &&
          _screenWidth != null) {
        _currentIndex = (_currentIndex + 1) % widget.posts.length;

        _scrollController.animateTo(
          _currentIndex *
              (_screenWidth! -
                  32), // Adjust with 90% of screen width for the card size
          duration: Duration(
              milliseconds: 700), // Increase duration for smooth scroll
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: widget.posts
            .map((post) => _buildDiscussionCardWidget(post))
            .toList(),
      ),
    );
  }

  // Builds a discussion card for a trending post.
  Widget _buildDiscussionCardWidget(Post post) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                // Print the values before passing them to the new page
                print('Post ID: ${post.id}');
                print('Topic: ${post.topicName}');
                print(
                    'Avatar URL: post.'); // The actual avatar URL is missing here, be sure to replace it with the correct value.
                print('User Name: ${post.authorName}');
                print('Post Time: ${post.createdAt}');
                print('Post Text: ${post.content}');
                print(
                    'Post Media URL: ${post.mediaUrls.isNotEmpty ? post.mediaUrls.first : 'No media URL available'}');

                return PostWithCommentsPage(
                  postId: post.id,
                  Topic: post.topicName,
                  avatarUrl: post
                      .author_profile_picture, // Replace with the correct URL for the avatar
                  userName: post.authorName,
                  postTime: post.createdAt,
                  postText: post.content,
                  postMediaUrl: post.mediaUrls.isNotEmpty
                      ? post.mediaUrls.first
                      : "", // Handle empty media URLs
                );
              },
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.9, // This makes the container take up the full width of the screen
          margin: EdgeInsets.only(bottom: 16, right: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: deepBlueColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    maxRadius: 25,
                    backgroundImage: NetworkImage(post.author_profile_picture),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      Text(
                        post.createdAt.toString().substring(0, 10),
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                post.content,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(height: 10),
              // Adding the three white dots at the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 20,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(20), // Adding border radius
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
