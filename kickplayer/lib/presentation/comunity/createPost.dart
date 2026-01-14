import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Kaledal/Models/community.dart';
import 'dart:io';

import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postController = TextEditingController();
  List<PinnedTopic> hashtags = [];
  List<XFile> mediaFiles = [];
  final ImagePicker _picker = ImagePicker();
  List<PinnedTopic> availableHashtags = [];

  Future<void> _pickMedia(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        mediaFiles.add(pickedFile);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchHashtags(); // Fetch hashtags on initialization
  }

  Future<void> _fetchHashtags() async {
    try {
      FeedResponse response = await fetchFeed();
      setState(() {
        availableHashtags = response.pinnedTopics; // Update available hashtags
      });
    } catch (e) {
      print("Error fetching hashtags: $e");
    }
  }

  Future<FeedResponse> fetchFeed() async {
    final response = await http.get(
      Uri.parse('https://api.kickplayer.net/community/feed'),
      headers: {'accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return FeedResponse.fromJson(data);
    } else {
      throw Exception('Failed to load feed');
    }
  }

  void _showHashtagSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setSta) {
            return Container(
              color: Colors.white, // Background set to white
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Hashtags",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: deepBlueColor, // Custom color
                    ),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: ListView(
                      children: availableHashtags.map((hashtag) {
                        bool isSelected = hashtags.contains(hashtag);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              setSta(() {
                                hashtags.clear();
                                hashtags.add(hashtag);
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue[100] // Highlight selected
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? deepBlueColor : Colors.grey,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 12),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.circle,
                                  color:
                                      isSelected ? deepBlueColor : Colors.grey,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  hashtag.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? deepBlueColor
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 15),
                  // Full-width button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: mainblue, // Custom button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Done",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
          icon: Icon(
            Icons.arrow_back,
            color: deepBlueColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Community",
          style: TextStyle(fontSize: 18, color: deepBlueColor),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              // Handle search action
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Icon(
                Icons.search,
                color: mainblue,
              ),
            ),
          ),
          GestureDetector(
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
          ),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Posts",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: deepBlueColor)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Lightgrey, width: 0.5),
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.blue, width: 1), // Blue border
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage("assets/avatar.png"),
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Salim Alaoui",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Wrap(
                            spacing: 4, // Less spacing between items
                            runSpacing: 4, // Space between lines
                            children: hashtags.isEmpty
                                ? [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical:
                                              8), // Padding for the container
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .blue[100], // Background color
                                        borderRadius: BorderRadius.circular(
                                            10), // Similar to the StadiumBorder shape
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          _showHashtagSelectionBottomSheet();
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(width: 12),
                                            Text(
                                              "Select Topic",
                                              style: TextStyle(
                                                  color:
                                                      deepBlueColor), // Text color matching foregroundColor
                                            ),
                                            SizedBox(width: 12),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]
                                : hashtags.map((tags) {
                                    return GestureDetector(
                                      onTap:
                                          _showHashtagSelectionBottomSheet, // Show bottom sheet when tapping a selected hashtag
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth:
                                                200), // Adjust width if needed
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4), // Minimal padding
                                        decoration: BoxDecoration(
                                          color:
                                              superlightblue, // Blue background
                                          borderRadius: BorderRadius.circular(
                                              5), // Rounded corners
                                        ),
                                        child: Text(
                                          tags.name,
                                          style: TextStyle(
                                              color: deepBlueColor,
                                              fontSize: 12), // Black text
                                          softWrap: true, // Ensures wrapping
                                          overflow: TextOverflow
                                              .visible, // Prevents cutting off text
                                        ),
                                      ),
                                    );
                                  }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  PostField(
                    label: "",
                    hintText: "How can I improve my physical skills?",
                    controller: _postController,
                    enabled: false,
                  ),
                  SizedBox(height: 12),
                  if (mediaFiles.isNotEmpty)
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mediaFiles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(mediaFiles[index].path),
                                  width: 80, height: 80, fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton(Icons.image, "Image",
                          () => _pickMedia(ImageSource.gallery)),
                      _buildButton(Icons.videocam, "Video",
                          () => _pickMedia(ImageSource.camera)),
                      _buildButton(Icons.attach_file, "Other", () {}),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                _showLoader(context); // Show loading
                try {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? userId = prefs.getString('user_id');
                  String postText = _postController.text;
                  String topicId = hashtags.isNotEmpty && hashtags[0].id != null
                      ? hashtags[0].id.toString()
                      : "1";

                  String apiUrl =
                      "https://api.kickplayer.net/community/posts/create-new/$userId";

                  List<String> base64Files = [];

                  for (var file in mediaFiles) {
                    File imageFile = File(file.path);
                    List<int> imageBytes = await imageFile.readAsBytes();
                    String base64Image = base64Encode(imageBytes);
                    base64Files.add(base64Image);
                  }

                  var request =
                      http.MultipartRequest('POST', Uri.parse(apiUrl));

                  request.fields['content'] = postText;
                  request.fields['topic_id'] = topicId;

                  // Send only one file base64 if needed
                  if (base64Files.isNotEmpty) {
                    request.fields['files'] =
                        base64Files.first; // or join with ',' if multiple
                  }

                  var response = await request.send();
                  final responseBody = await response.stream.bytesToString();

                  print("Status Code: ${response.statusCode}");
                  print("Response Body: $responseBody");
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    _showResultDialog(
                        context, true, "🎉 Post published successfully!");
                  } else {
                    _showResultDialog(
                        context, false, "❌ Failed to publish post.");
                  }
                } catch (e) {
                  print("❗ Error: $e");
                  _showResultDialog(context, false, "⚠️ Error: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Publish",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 3, horizontal: 6), // Minimal padding
      decoration: BoxDecoration(
        border: Border.all(color: Lightgrey, width: 0.5),
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.blue, size: 24), // Blue icon
            SizedBox(width: 4), // Small spacing
            Text(label,
                style:
                    TextStyle(color: Colors.black, fontSize: 12)), // Black text
          ],
        ),
      ),
    );
  }

  void _showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    );
  }

  void _showResultDialog(BuildContext context, bool success, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red),
            SizedBox(width: 8),
            Text(success ? "Success" : "Error",
                style: TextStyle(color: success ? Colors.green : Colors.red)),
          ],
        ),
        content: Text(message,
            style: TextStyle(fontSize: 14, color: Colors.black87)),
        actions: [
          TextButton(
            child: Text("OK", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              if (success) {
                Navigator.of(context).pop();
              }
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
