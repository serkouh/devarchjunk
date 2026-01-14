import 'dart:convert';
import 'dart:io';

import 'package:Kaledal/presentation/home/record_challenge.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';
import 'package:video_player/video_player.dart';

class ProfileUploadScreen extends StatefulWidget {
  final Function(File) onDataChanged;
  final Function(File) onDataChangedv;
  ProfileUploadScreen(
      {required this.onDataChanged, required this.onDataChangedv});

  @override
  _ProfileUploadScreenState createState() => _ProfileUploadScreenState();
}

class _ProfileUploadScreenState extends State<ProfileUploadScreen> {
  File? _profileImage;
  File? _videoFile;
  VideoPlayerController? _videoController;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      widget.onDataChanged(_profileImage!); // Send binary data
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
        _videoController = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {});
            _videoController!.setLooping(true);
          });
      });

      widget.onDataChangedv(_videoFile!); // Send binary data
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 0),
                width: screenWidth * 0.8,
                child: H2TITLE('Complete Information'),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Upload Profile Image",
              style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            SizedBox(height: screenHeight * 0.01),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.18, // 150px relative to screen height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: deepgrey, width: 2),
                  color: Colors.white,
                ),
                child: _profileImage == null
                    ? Center(
                        child: Image.asset(
                        'assets/images/uplaod image 1.png',
                        width: 60,
                        height: 60,
                      ))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_profileImage!,
                            width: double.infinity,
                            height: screenHeight * 0.18,
                            fit: BoxFit.cover),
                      ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Upload Video Introduction",
              style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            SizedBox(height: screenHeight * 0.01),
            GestureDetector(
              onTap: _pickVideo,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.25, // 200px relative to screen height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: deepgrey, width: 2),
                  color: Colors.white,
                ),
                child: _videoFile == null
                    ? Center(
                        child: Image.asset(
                        'assets/images/uplaod image 1 (1).png',
                        width: 70,
                        height: 70,
                      ))
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenVideo(
                                        controller: _videoController!),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: AspectRatio(
                                  aspectRatio:
                                      _videoController!.value.aspectRatio,
                                  child: VideoPlayer(_videoController!),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                                _videoController!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 50,
                                color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _videoController!.value.isPlaying
                                    ? _videoController!.pause()
                                    : _videoController!.play();
                              });
                            },
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
