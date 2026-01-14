import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart'; // Add this line

class ChatInputWidget extends StatefulWidget {
  final int roomId;
  final String otherid;
  final Function(String) reb;
  const ChatInputWidget(
      {super.key,
      required this.roomId,
      required this.otherid,
      required this.reb});

  @override
  _ChatInputWidgetState createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  TextEditingController _messageController = TextEditingController();
  bool isRecording = false;
  File? pickedFile;
  File? voiceNote;
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _recordedPath;
  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {});
    });

    _initRecorder();
  }

  void _initRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<void> _sendMessage({
    String? content,
    File? mediaAttachment,
    File? voiceNote,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? authToken = prefs.getString('auth_token');
    String room = '';
    print(widget.roomId);
    print(userId);
    final url = Uri.parse('https://api.kickplayer.net/chat/messages');

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      });

      request.fields['room_id'] = widget.roomId.toString();
      request.fields['sender_id'] = userId ?? '0';
      request.fields['recipient_id'] = widget.otherid ?? '0';

      if (content != null && content.isNotEmpty) {
        request.fields['content'] = content;
      }

      if (mediaAttachment != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'media_attachment',
          mediaAttachment.path,
          filename: basename(mediaAttachment.path),
          contentType: MediaType('image', 'png'),
        ));
      }
      print(voiceNote?.path);
      if (voiceNote != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'voice_note',
          voiceNote.path,
          filename: basename(voiceNote.path),
          contentType: MediaType('audio', 'aac'),
        ));
      }

      final response = await request.send();

      // Read the response body
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('✅ Message sent successfully');
        print('📨 Response body: $responseBody');
        var responseData = json.decode(responseBody);
        var roomId = responseData['room_id'].toString();
        setState(() {
          _messageController.clear();
          pickedFile = null;
          this.voiceNote = null;
          room = roomId;
        });

        // Optional: fetchMessages();
      } else {
        print('❌ Failed to send message. Code: ${response.statusCode}');
        print('📨 Error response: $responseBody');
      }
    } catch (e) {
      print('❌ Error: $e');
    }
    widget.reb(room);
  }

  void _pickAttachment() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedFile = File(image.path);
      });

      // await _sendMessage(mediaAttachment: pickedFile);
    }
  }

  /// Starts recording audio
  void _startRecording() async {
    final tempDir = await getTemporaryDirectory();
    _recordedPath =
        '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.openRecorder();
    await _recorder.startRecorder(
      toFile: _recordedPath,
      codec: Codec.aacMP4, // Use m4a which is iOS-friendly
    );

    setState(() {
      isRecording = true;
    });
  }

  /// Stops recording and prepares the audio file
  void _stopRecording() async {
    await _recorder.stopRecorder();
    await _recorder.closeRecorder();

    setState(() {
      isRecording = false;
      voiceNote = File(_recordedPath!);
    });

    if (voiceNote != null && await voiceNote!.exists()) {
      // await _sendMessage(voiceNote: voiceNote);
    }
  }

  bool isSending = false;

  /// Handle send button
  void _handleSendPressed() async {
    String text = _messageController.text.trim();
    if (text.isNotEmpty || pickedFile != null || voiceNote != null) {
      if (!isSending) {
        setState(() {
          isSending = true;
        });
        try {
          await _sendMessage(
            content: text.isNotEmpty ? text : null,
            mediaAttachment: pickedFile,
            voiceNote: voiceNote,
          );
        } catch (e) {
          // handle error
        }
      }
    } else {
      _startRecording();
    }
    setState(() {
      isSending = false;
    });
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickAttachment,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Color(0xFFE35B0F),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pickedFile != null || voiceNote != null)
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          pickedFile != null
                              ? Icons.insert_drive_file
                              : Icons.mic,
                          color: pickedFile != null ? Colors.blue : Colors.red,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            pickedFile != null
                                ? basename(pickedFile!.path)
                                : "Voice Note Recorded",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 18),
                          onPressed: () {
                            setState(() {
                              pickedFile = null;
                              voiceNote = null;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                isRecording
                    ? RecordingWidget(onStop: _stopRecording)
                    : TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Write your message...",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: _handleSendPressed,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: isSending
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(
                      (_messageController.text.trim().isNotEmpty ||
                              pickedFile != null ||
                              voiceNote != null)
                          ? Icons.send
                          : Icons.mic,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecordingWidget extends StatefulWidget {
  final VoidCallback onStop;

  const RecordingWidget({required this.onStop, super.key});

  @override
  _RecordingWidgetState createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [lightblue, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: mainblue.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.mic, color: mainblue, size: 28),
          SizedBox(width: 12),
          Text(
            "Recording...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Spacer(),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomPaint(
                painter: WaveformPainter(_controller.value),
                size: Size(40, 20),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.stop_circle, color: Colors.black87, size: 28),
            onPressed: widget.onStop,
          ),
        ],
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double progress;
  WaveformPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final midY = size.height / 2;
    final waveHeight = 8 * progress;
    for (int i = 0; i < size.width; i += 8) {
      final dx = i.toDouble();
      final dy = midY + sin((i + progress * 360) * 0.2) * waveHeight;
      canvas.drawLine(Offset(dx, midY), Offset(dx, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
