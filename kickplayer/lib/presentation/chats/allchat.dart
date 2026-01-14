import 'package:Kaledal/presentation/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/chats/newchat.dart';
import 'package:Kaledal/presentation/chats/onechat%20copy.dart';
import 'package:Kaledal/presentation/chats/onechat.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController passwordController = TextEditingController();
  List<dynamic> chatRooms = [];
  bool isSearching = false;
  String? userId;
  String selectedChip = 'All';

  @override
  void initState() {
    super.initState();
    _initialize();
    passwordController.addListener(_onSearchChanged);
  }

  void _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
    _fetchChatRooms(); // fetch initial data
  }

  void _onSearchChanged() {
    final query = passwordController.text.trim();
    if (query.isNotEmpty) {
      _searchChatRooms(query);
    } else {
      _fetchChatRooms();
    }
  }

  Future<void> _fetchChatRooms() async {
    if (userId == null) return;

    final response = await http.get(
      Uri.parse('https://api.kickplayer.net/chat/rooms/?user_id=$userId'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> rooms = json.decode(response.body);

      // Sort rooms by last_message.timestamp (newest first)
      rooms.sort((a, b) {
        final aTimestamp = a['last_message']?['timestamp'];
        final bTimestamp = b['last_message']?['timestamp'];

        // Handle possible nulls
        if (aTimestamp == null && bTimestamp == null) return 0;
        if (aTimestamp == null) return 1;
        if (bTimestamp == null) return -1;

        return DateTime.parse(bTimestamp).compareTo(DateTime.parse(aTimestamp));
      });

      setState(() {
        chatRooms = rooms;
      });
    } else {
      throw Exception('Failed to load chat rooms');
    }
  }

  Future<void> _searchChatRooms(String query) async {
    if (userId == null) return;

    final response = await http.get(
      Uri.parse(
          'https://api.kickplayer.net/chat/rooms/search?user_id=$userId&query=$query'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        chatRooms = json.decode(response.body);
      });
    } else {
      throw Exception('Search failed');
    }
  }

  @override
  void dispose() {
    passwordController.removeListener(_onSearchChanged);
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) => NewChatSheet(
              reloadChats: _initialize,
            ),
          );
        },
        backgroundColor: mainblue, // Optional: Customize color
        child: Icon(Icons.add, color: Colors.white), // The "+" icon
      ),
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Messages",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SeachFeild(
                label: '',
                controller: passwordController,
                icon: Icons.search,
                hintText: 'Search',
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterChip('All'),
                    _buildFilterChip('Groups'),
                    _buildFilterChip('Community'),
                    _buildFilterChip('Unread'),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _buildMessageSection('All Messages', [
                chatRooms.isEmpty
                    ? Center(child: Text('No messages available'))
                    : Column(
                        children: chatRooms.map<Widget>((room) {
                          print(room['last_message']);
                          return _buildMessageTile(
                            room['other_user']['name'],
                            room['last_message']['content'] ??
                                room['last_message']['type'],
                            _formatDateTime(room['last_message']['timestamp']),
                            room['room_id'],
                            room['other_user']['profile_picture'] ??
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqafzhnwwYzuOTjTlaYMeQ7hxQLy_Wq8dnQg&s',
                            room['other_user']['id'].toString(),
                            unreadCount: 0,
                          );
                        }).toList(),
                      ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    final DateTime dateTime = DateTime.parse(dateTimeStr);
    return '${dateTime.hour}:${dateTime.minute}';
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedChip == label,
        onSelected: (selected) {
          setState(() {
            selectedChip = label;
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selectedColor: mainblue,
        backgroundColor: lightblue,
        labelStyle:
            TextStyle(color: selectedChip == label ? Colors.white : mainblue),
      ),
    );
  }

  Widget _buildMessageSection(String title, List<Widget> messages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
                title == "Pinned Messages"
                    ? Icons.push_pin
                    : Icons.message_sharp,
                size: 16,
                color: deepgrey),
            SizedBox(
              width: 10,
            ),
            Text(title,
                style: TextStyle(
                    /*fontWeight: FontWeight.bold, */ color: deepgrey)),
          ],
        ),
        Column(children: messages),
      ],
    );
  }

  Widget _buildMessageTile(String name, String message, String time, int id,
      String image, String otherid,
      {int unreadCount = 0,
      bool seen = false,
      bool online = false,
      bool voice = false,
      bool missedCall = false,
      bool file = false}) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => unreadCount == 0
                  ? FrankfurtMessagePage(
                      otherid: otherid,
                      sender: name,
                      roomId: id,
                      reloadChats: _initialize,
                    )
                  : FrankfurtMessagePageDemo(
                      roomId: 0,
                    ),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: deepgrey, backgroundImage: NetworkImage(image)),
          title: Row(
            children: [
              Text(name, style: TextStyle()),
            ],
          ),
          subtitle: Row(
            children: [
              if (seen) Icon(Icons.done_all, color: mainblue, size: 16),
              if (voice) Icon(Icons.mic, size: 16, color: mainblue),
              if (missedCall)
                Icon(Icons.call_missed, size: 16, color: Colors.red),
              if (file)
                Icon(Icons.insert_drive_file, size: 16, color: deepgrey),
              SizedBox(width: 5),
              Expanded(
                  child: Text(message,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: deepgrey))),
            ],
          ),
          trailing: Column(
            children: [
              Text(time, style: TextStyle(fontSize: 12)),
              if (unreadCount > 0)
                CircleAvatar(
                    radius: 10,
                    backgroundColor: mainblue,
                    child: Text('$unreadCount',
                        style: TextStyle(fontSize: 12, color: Colors.white))),
            ],
          ),
        ));
  }
}
