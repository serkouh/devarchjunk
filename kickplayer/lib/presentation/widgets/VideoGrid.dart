import 'dart:ui';

import 'package:Kaledal/presentation/home/record_challenge.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class VideoGridView extends StatefulWidget {
  @override
  _VideoGridViewState createState() => _VideoGridViewState();
}

class _VideoGridViewState extends State<VideoGridView> {
  List<String> videoUrls = [];
  String errorMessage = "";

  final List<String> thumbnailUrls = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Football_in_Bloomington%2C_Indiana%2C_1995.jpg/500px-Football_in_Bloomington%2C_Indiana%2C_1995.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Football_in_Bloomington%2C_Indiana%2C_1995.jpg/500px-Football_in_Bloomington%2C_Indiana%2C_1995.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Football_in_Bloomington%2C_Indiana%2C_1995.jpg/500px-Football_in_Bloomington%2C_Indiana%2C_1995.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Football_in_Bloomington%2C_Indiana%2C_1995.jpg/500px-Football_in_Bloomington%2C_Indiana%2C_1995.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Football_in_Bloomington%2C_Indiana%2C_1995.jpg/500px-Football_in_Bloomington%2C_Indiana%2C_1995.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Football_in_Bloomington%2C_Indiana%2C_1995.jpg/500px-Football_in_Bloomington%2C_Indiana%2C_1995.jpg",
  ];

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  bool isLoading = true;

  Future<void> fetchVideos() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    try {
      final response = await http
          .get(Uri.parse('https://api.kickplayer.net/users/$userId/videos'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['videos'];
        setState(() {
          videoUrls = List<String>.from(
              data.map((item) => item['video_url'].toString()));
          errorMessage = "";
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load videos. Please try again later.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching videos: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: errorMessage.isNotEmpty
          ? Center(
              child: Text(errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16)))
          : isLoading
              ? Center(child: CircularProgressIndicator())
              : videoUrls.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: videoUrls.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _showVideoDialog(context, videoUrls[index]);
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
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
                                    thumbnailUrls[index %
                                        thumbnailUrls
                                            .length], // Static thumbnails
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }

  void _showVideoDialog(BuildContext context, String videoUrl) {
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
                        VideoPlayerDialog(videoUrl: videoUrl),

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
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_off,
            size: 100,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 20),
          Text(
            "No videos available",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Once you add a video, it will appear here.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class VideoPlayerDialog extends StatefulWidget {
  final String videoUrl;

  VideoPlayerDialog({required this.videoUrl});

  @override
  _VideoPlayerDialogState createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late VideoPlayerController _controller;
  bool hasError = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isPlaying = true;
        });
        _controller.play();
      }).catchError((error) {
        setState(() {
          hasError = true;
        });
      });

    // Listen to changes in the video playback
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Toggle play and pause
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

  // Format time in MM:SS
  String _formatDuration(Duration duration) {
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return hasError
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, color: Colors.red, size: 50),
                SizedBox(height: 10),
                Text("Failed to load video",
                    style: TextStyle(color: Colors.red, fontSize: 16)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close"),
                ),
              ],
            ),
          )
        : _controller.value.isInitialized
            ? Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  color: Colors.white, // Set background to white
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenVideo(
                                        controller: _controller!),
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
                            if (!_isPlaying)
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
                              ),
                            if (_isPlaying)
                              GestureDetector(
                                onTap: _togglePlayPause,
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                          ],
                        ),
                      ),
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator());
  }
}
