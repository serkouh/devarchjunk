import 'dart:io';

import 'package:Kaledal/presentation/chats/Voiceplayer.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/chat_input.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http_parser/http_parser.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FrankfurtMessagePage extends StatefulWidget {
  final int roomId;
  final String sender;
  final String otherid;
  final VoidCallback reloadChats; // <-- Add this line

  FrankfurtMessagePage({
    required this.roomId,
    required this.sender,
    required this.otherid,
    required this.reloadChats, // <-- Include it in the constructor
  });

  @override
  _FrankfurtMessagePageState createState() => _FrankfurtMessagePageState();
}

class _FrankfurtMessagePageState extends State<FrankfurtMessagePage> {
  late FlutterSoundPlayer _audioPlayer;
  bool _isPlayerReady = false;

  Future<void> _initializePlayer() async {
    await _audioPlayer.openPlayer();
    setState(() {
      _isPlayerReady = true;
    });
  }

  @override
  void dispose() {
    _audioPlayer.closePlayer();
    super.dispose();
  }

  List<Map<String, dynamic>> messages = [];
  TextEditingController _messageController = TextEditingController();
  String? userId;
  String? authToken; // To store the token for headers

  // Fetch messages from API
  Future<void> fetchMessages([String? room]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
    authToken = prefs.getString(
        'auth_token'); // Assuming token is saved in SharedPreferences
    print(authToken);

    final url =
        'https://api.kickplayer.net/chat/rooms/${room ?? widget.roomId}/messages?current_user_id=$userId';
    print(url);
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken', // Add token here
        },
      );
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

  // Send message to API
  Future<void> sendMessage({
    String? content,
    File? mediaAttachment,
    File? voiceNote,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
    authToken = prefs.getString('auth_token');

    final url = Uri.parse('https://api.kickplayer.net/chat/messages');

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      });

      // Required fields
      request.fields['room_id'] = widget.roomId.toString();
      request.fields['sender_id'] = userId ?? '0';
      request.fields['recipient_id'] = '0'; // Change if you use a recipient_id

      // Optional text content
      if (content != null && content.isNotEmpty) {
        request.fields['content'] = content;
      }

      // Optional media attachment
      if (mediaAttachment != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'media_attachment',
          mediaAttachment.path,
        ));
      }

      // Optional voice note
      if (voiceNote != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'voice_note',
            voiceNote.path,
            contentType:
                MediaType('audio', 'aac'), // Utilisez "audio/m4a" si besoin
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        _messageController.clear();
        fetchMessages();
      } else {
        print('Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
    _audioPlayer = FlutterSoundPlayer();
    _initializePlayer();
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isSentByMe = message['sender_id'].toString() == userId;

    // Check if there's an attachment
    String? attachmentUrl = message['attachment_url'];
    String? content = message['content'];

    // Function to check if URL points to an audio file (based on its extension)
    bool isAudioFile(String url) {
      print("++++++++++" + url);
      return url.endsWith('.mp3') ||
          url.endsWith('.wav') ||
          url.endsWith('.aac') ||
          url.endsWith('.m4a');
    }

    // Function to check if URL points to an image (based on its extension)
    bool isImageFile(String url) {
      print(url);
      return url.endsWith('.png') ||
          url.endsWith('.jpg') ||
          url.endsWith('.jpeg');
    }

    // Function to check if URL points to a document (based on its extension)
    bool isDocumentFile(String url) {
      return url.endsWith('.pdf') ||
          url.endsWith('.docx') ||
          url.endsWith('.xlsx');
    }

    // Display the message bubble with different content based on file type or text
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: !isSentByMe ? Colors.blue[100] : mainblue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: isSentByMe ? Radius.circular(10) : Radius.zero,
                bottomRight: isSentByMe ? Radius.zero : Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: isSentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Check attachment and display accordingly
                if (attachmentUrl != null && attachmentUrl.isNotEmpty) ...[
                  // Check if the file is an audio file
                  if (isAudioFile(attachmentUrl))
                    AudioPlayerWidget(url: attachmentUrl),

                  // Check if the file is an image
                  if (isImageFile(attachmentUrl))
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          memCacheWidth: 300,
                          memCacheHeight: 300,
                          imageUrl: attachmentUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  // Check if the file is a document (e.g., PDF, DOCX)
                  if (isDocumentFile(attachmentUrl))
                    InkWell(
                      onTap: () {
                        // Handle file opening logic here
                      },
                      child: Text(
                        'Document: Tap to open',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                ] else ...[
                  // Display text content if no attachment
                  Text(
                    content ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: !isSentByMe ? Colors.black : Colors.white,
                    ),
                  ),
                ],
                SizedBox(height: 5),
              ],
            ),
          ),
          Text(
            message['timestamp']
                .toString()
                .substring(11, 16), // Ensure timestamp is a readable format
            style: TextStyle(
              fontSize: 10,
              color: deepgrey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          '${widget.sender}',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: Icon(Icons.flag),
            onPressed: () {
              // Handle flag tap
            },
          ),
          PopupMenuButton<String>(
            color: Colors.white, // White background for the menu
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'report') {
                // Handle report
              } else if (value == 'delete') {
                // Handle delete
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'report',
                child: Text('Report'),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          ChatInputWidget(
            reb: (room) {
              fetchMessages(room);
              widget.reloadChats();
            },
            otherid: widget.otherid,
            roomId: widget.roomId,
          ),
          /* Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Write your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: mainblue),
                  onPressed: () {
                    String content = _messageController.text;
                    if (content.isNotEmpty) {
                      sendMessage(content); // Send the message
                    }
                  },
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
}
