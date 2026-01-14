import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool generalNotifications = true;
  bool messagesAndChats = true;
  bool matches = false;
  bool newOffers = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Notifications Preferences',
          style: TextStyle(
            color: deepBlueColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SwitchTile(
            title: 'General Notifications',
            value: generalNotifications,
            onChanged: (val) => setState(() => generalNotifications = val),
          ),
          SwitchTile(
            title: 'Messages and Chats',
            value: messagesAndChats,
            onChanged: (val) => setState(() => messagesAndChats = val),
          ),
          SwitchTile(
            title: 'Matches',
            value: matches,
            onChanged: (val) => setState(() => matches = val),
          ),
          SwitchTile(
            title: 'New Offers',
            value: newOffers,
            onChanged: (val) => setState(() => newOffers = val),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Save action
                },
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      title: Text(
        title,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: Colors.blue,
      ),
    );
  }
}
