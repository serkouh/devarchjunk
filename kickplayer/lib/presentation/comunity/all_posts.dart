import 'package:Kaledal/presentation/chats/allchat.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/posts.dart';

class onlyposts extends StatelessWidget {
  final String title;

  // Constructor with the title parameter
  onlyposts({required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            title, // Dynamically use the title parameter here
            style: TextStyle(fontSize: 18, color: deepBlueColor),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MessagesScreen()),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  'assets/images/messages icon.png',
                  width: 30,
                  height: 30,
                  color: mainblue,
                ),
              ),
            ),
          ],
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          // Wrap the body in a SingleChildScrollView
          child: PostWithComments(), // Your scrollable content
        ),
      ),
    );
  }
}
