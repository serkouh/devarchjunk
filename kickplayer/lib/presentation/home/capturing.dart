import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/home/results_ai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import 'package:shared_preferences/shared_preferences.dart';

class VideoCaptureScreen extends StatefulWidget {
  final String videoTitle;

  VideoCaptureScreen({required this.videoTitle});
  @override
  _VideoCaptureScreenState createState() => _VideoCaptureScreenState();
}

class _VideoCaptureScreenState extends State<VideoCaptureScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool isRecording = false;
  File? _videoFile;

  @override
  void initState() {
    super.initState();
    print("Initializing VideoRecord screen");
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    print("Initializing camera...");
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.high);
    _initializeControllerFuture = _cameraController.initialize();
    setState(() {});
    print("Camera initialized.");
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      print("Starting recording...");
      await _initializeControllerFuture;
      final directory = await getTemporaryDirectory();
      final videoPath = '${directory.path}/video.mp4';
      await _cameraController.startVideoRecording();
      setState(() => isRecording = true);
      print("Recording started at $videoPath");
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      print("Stopping recording...");
      final file = await _cameraController.stopVideoRecording();
      setState(() {
        isRecording = false;
        _videoFile = File(file.path);
      });
      print("Recording stopped. Video saved at: ${file.path}");
      _showConfirmationSheet();
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  Future<void> _pickVideoFromGallery() async {
    print("Picking video from gallery...");
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _videoFile = File(pickedFile.path));
      print("Video selected: ${pickedFile.path}");
      _showConfirmationSheet();
    } else {
      print("No video selected.");
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null) {
      print("No video file selected.");
      return;
    }

    try {
      _showLoading();
      print("Preparing to upload video: ${_videoFile!.path}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      var uri =
          Uri.parse("https://api.kickplayer.net/submit-challenge/$userId");
      var request = http.MultipartRequest("POST", uri);

      // Add challenge_id
      request.fields['challenge_id'] = widget.videoTitle;

      // Attach the video file
      request.files.add(await http.MultipartFile.fromPath(
        'video',
        _videoFile!.path,
        contentType:
            MediaType('video', 'mp4'), // ← equivalent to `type=video/mp4`
      ));

      print("Sending request to $uri...");
      var response = await request.send();

      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("✅ Video uploaded successfully.");
        print("Server response: $responseBody");
      } else {
        print("❌ Upload failed with status code: ${response.statusCode}");
        print("Server response: $responseBody");
      }
    } catch (e) {
      print("⚠️ Upload error: $e");
    } finally {
      _hideLoading();
      _showAnalyticsDialog();
    }
  }

  bool _isLoading = false;

  void _showLoading() {
    setState(() => _isLoading = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoading() {
    setState(() => _isLoading = false);
    Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
  }

  void _showConfirmationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the sheet extend to full width
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          color: Colors.white, // White background
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Make sure this is what you want before confirming.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showAnalyticsDialog();
                      // _uploadVideo();
                      // Close bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        Text('Confirm', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(
                          context); // Close bottom sheet without action
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: mainblue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Cancel', style: TextStyle(color: mainblue)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAnalyticsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, // White background
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), // Set radius for the dialog
          ),
          content: Text(
            'We will notify you when Kickplayer AI finishes analyzing the video.',
            style: TextStyle(fontSize: 16), // Content text styling
          ),
          actions: <Widget>[
            Container(
              width: double.infinity, // Make the button take full width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PowerShotResults(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainblue, // Blue background for the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Rounded corners for the button
                  ),
                ),
                child: Text(
                  'OK',
                  style:
                      TextStyle(color: Colors.white), // White text for button
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: deepBlueColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Record video", // Dynamically use the title parameter here
          style: TextStyle(fontSize: 18, color: deepBlueColor),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomSheet: Container(
        color: Colors.white, // White background
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () {
                _pickVideoFromGallery();
                print("Gallery clicked");
              },
            ),
            ElevatedButton(
              onPressed: isRecording ? _stopRecording : _startRecording,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red color for recording button
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
              ),
              child: Icon(
                isRecording ? Icons.stop : Icons.videocam,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}
