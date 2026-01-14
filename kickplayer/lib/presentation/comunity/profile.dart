import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePictureWidget extends StatefulWidget {
  final String imageUrl;
  final Color borderColor;

  const ProfilePictureWidget({
    super.key,
    required this.imageUrl,
    required this.borderColor,
  });

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery, // or .camera
      imageQuality: 85,
    );

    if (picked != null) {
      final file = File(picked.path);
      setState(() => _imageFile = file);
      await _uploadImage(file);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse('https://api.kickplayer.net/update-profile-picture/$userId'),
    );

    request.headers.addAll({
      'accept': 'application/json',
    });

    final fileName = path.basename(imageFile.path);

    request.files.add(
      await http.MultipartFile.fromPath(
        'profile_picture',
        imageFile.path,
        filename: fileName,
        contentType: MediaType('image', 'png'), // Adjust based on file type
      ),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      print("✅ Upload successful");
    } else {
      print("❌ Upload failed: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _imageFile != null
        ? FileImage(_imageFile!)
        : NetworkImage(widget.imageUrl) as ImageProvider;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 104,
        height: 104,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: widget.borderColor, width: 4),
        ),
        child: CircleAvatar(
          radius: 50,
          backgroundImage: imageProvider,
        ),
      ),
    );
  }
}
