import 'dart:io';

import 'package:Kaledal/presentation/home/record_challenge.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class FrankfurtMessagePageDemo extends StatefulWidget {
  final int roomId;

  FrankfurtMessagePageDemo({required this.roomId});

  @override
  _FrankfurtMessagePageDemoState createState() =>
      _FrankfurtMessagePageDemoState();
}

class _FrankfurtMessagePageDemoState extends State<FrankfurtMessagePageDemo> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController _messageController = TextEditingController();

  Future<void> fetchMessages() async {
    final url =
        'https://api.kickplayer.net/chat/rooms/${widget.roomId}/messages';
    try {
      final response = await http
          .get(Uri.parse(url), headers: {'accept': 'application/json'});
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          messages =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        print('Failed to load messages');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  bool _isDeclined = false;
  bool _isAccepted = false;
  bool _showMessageInput = false;
  String _sentMessage = "";
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    _videoController = VideoPlayerController.network(
        'https://videos.pexels.com/video-files/6077689/6077689-uhd_1440_2560_25fps.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 7,
            ),
            SizedBox(width: 10),
            Text(
              'Frankfurt',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: 10),
            Icon(Icons.check_circle, color: mainblue, size: 16),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    reverse: true, // To make the list scroll from bottom to top
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Hello Ahmad Madani, we have been following your progress on kickplayer and analyzing your AI-generated reports. Based on our benchmarking system, we see strong potential in your playing style. We\'d like to discuss more about your ambitions and potential opportunities with our club. Please let us know if you\'re open to a conversation.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '12:08 pm',
                            style: TextStyle(fontSize: 12, color: deepgrey),
                          ),
                          SizedBox(height: 10),
                          // Video message (Placeholder for actual video content)
                          _videoController != null &&
                                  _videoController!.value.isInitialized
                              ? Container(
                                  height: 200,
                                  width: double.infinity,
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
                                      padding:
                                          const EdgeInsets.only(bottom: 30.0),
                                      child: AspectRatio(
                                        aspectRatio:
                                            _videoController!.value.aspectRatio,
                                        child: VideoPlayer(_videoController!),
                                      ),
                                    ),
                                  ),
                                )
                              : Center(child: CircularProgressIndicator()),
                          SizedBox(height: 10),
                          Text(
                            'Video Message',
                            style: TextStyle(fontSize: 14, color: deepgrey),
                          ),
                          SizedBox(height: 10),
                          // PDF message
                          Container(
                              height:
                                  200, // Height for displaying PDF's first page
                              child: PDFScreen()),
                          SizedBox(height: 10),
                          Text(
                            'PDF Message: [Name of PDF]',
                            style: TextStyle(fontSize: 14, color: deepgrey),
                          ),
                          SizedBox(height: 10),
                          // Display sent message immediately upon button click
                          if (_showMessageInput)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: mainblue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _sentMessage,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          SizedBox(height: 10),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '12:08 pm',
                                style: TextStyle(fontSize: 12, color: deepgrey),
                              )),
                        ]))),
            _showMessageInput
                ? Row(
                    children: [
                      // Left side with a circle avatar and plus icon
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.orange,
                        child: IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            // Add more actions if needed
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Write your message...",
                            hintStyle: TextStyle(
                                color: deepgrey,
                                fontSize: 12), // Smaller hint text
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  4), // Thinner border radius
                              borderSide: BorderSide(
                                color: Colors
                                    .grey.shade200, // Dark black border color
                                width: 1, // Thinner border width
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  4), // Thinner border radius
                              borderSide: BorderSide(
                                color: Colors
                                    .grey.shade200, // Dark black border color
                                width: 1, // Thinner border width
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  4), // Thinner border radius
                              borderSide: BorderSide(
                                color: Colors
                                    .grey.shade200, // Dark black border color
                                width: 1, // Thinner border width
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Right side with the send icon
                      IconButton(
                        icon: Icon(Icons.send, color: mainblue),
                        onPressed: () {
                          setState(() {
                            // Send message and update UI
                            _sentMessage = _messageController.text;
                            _messageController.clear();
                          });
                        },
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isDeclined = true;
                            _isAccepted = false;
                            _sentMessage =
                                'Politely Declined'; // Send message immediately
                            _showMessageInput =
                                true; // Show input field after sending message
                          });
                        },
                        icon: Icon(Icons.thumb_down, color: Colors.red),
                        label: Text(
                          'Politely Decline',
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isAccepted = true;
                            _isDeclined = false;
                            _sentMessage =
                                'Accepted & Reply'; // Send message immediately
                            _showMessageInput =
                                true; // Show input field after sending message
                          });
                        },
                        icon: Icon(Icons.check, color: Colors.green),
                        label: Text(
                          'Accept & Reply',
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          backgroundColor: Colors.green[50],
                          foregroundColor: Colors.green,
                          side: BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
            if (!_showMessageInput) SizedBox(height: 10),
            if (!_showMessageInput)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.info_outline, color: mainblue),
                  label: Text('Request More Details'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    backgroundColor: Colors.blue[50],
                    foregroundColor: mainblue,
                    side: BorderSide(color: mainblue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    downloadAndSavePDF();
  }

  Future<void> downloadAndSavePDF() async {
    try {
      final url =
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/dummy.pdf');

      if (!await file.exists()) {
        final response = await Dio().download(url, file.path);
        print("PDF téléchargé avec succès");
      }

      setState(() {
        localFilePath = file.path;
      });
    } catch (e) {
      print("Erreur lors du téléchargement du PDF : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: localFilePath == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: 400,
              child: PDFView(
                filePath: localFilePath!,
                autoSpacing: true,
                enableSwipe: true,
                swipeHorizontal: false,
              ),
            ),
    );
  }
}
