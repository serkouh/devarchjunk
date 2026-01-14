import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Kaledal/presentation/chats/onechat.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart';

class Player {
  final int id;
  final String fullName;
  final String profilePicture;
  final List<String> positions;
  final int age;

  Player({
    required this.id,
    required this.fullName,
    required this.profilePicture,
    required this.positions,
    required this.age,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? 'Unknown',
      profilePicture: json['profile_picture'] ??
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqafzhnwwYzuOTjTlaYMeQ7hxQLy_Wq8dnQg&s',
      positions:
          json['positions'] != null ? List<String>.from(json['positions']) : [],
      age: json['age'] ?? 0,
    );
  }
}

class NewChatSheet extends StatefulWidget {
  final VoidCallback reloadChats; // <-- Add this line

  const NewChatSheet(
      {super.key, required this.reloadChats}); // <-- Add it in constructor

  @override
  State<NewChatSheet> createState() => _NewChatSheetState();
}

class _NewChatSheetState extends State<NewChatSheet> {
  List<Player> players = [];
  bool isLoading = true;
  String query = '';
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPlayers('');
    passwordController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = passwordController.text.trim();
    if (query.isNotEmpty) {
      fetchPlayers(query);
    } else {
      fetchPlayers('');
    }
  }

  Future<void> fetchPlayers(String q) async {
    setState(() {
      isLoading = true;
    });

    Uri url;

    if (q.isNotEmpty) {
      url = Uri.https('api.kickplayer.net', '/players/search', {'query': q});
    } else {
      url = Uri.https('api.kickplayer.net', '/players/search');
    }
    final response =
        await http.get(url, headers: {'accept': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        players = data.map((json) => Player.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      // Handle error (snackbar or log)
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white, // or your desired background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the start
            children: [
              const SizedBox(height: 10),
              Center(
                // Center the top handle only
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "New Chat",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SeachFeild(
                    label: '',
                    controller: passwordController,
                    icon: Icons.search,
                    hintText: 'Search',
                    keyboardType: TextInputType.text,
                  )),
              /* Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (value) {
                    query = value;
                    fetchPlayers(query);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search Field',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),*/
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          final player = players[index];
                          return ChatListTile(
                            reloadChats: widget.reloadChats,
                            id: player.id.toString(),
                            name: player.fullName,
                            role: player.positions.isNotEmpty
                                ? player.positions[0]
                                : 'Unknown',
                            age: player.age.toString(),
                            imageUrl: player.profilePicture,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChatListTile extends StatelessWidget {
  final String id;
  final String name;
  final String role;
  final String age;
  final String imageUrl;
  final VoidCallback reloadChats; // <-- Add this line

  const ChatListTile({
    super.key,
    required this.id,
    required this.name,
    required this.role,
    required this.age,
    required this.imageUrl,
    required this.reloadChats, // <-- Include it in the constructor
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FrankfurtMessagePage(
                otherid: id,
                sender: name,
                roomId: 0,
                reloadChats: reloadChats,
              ),
            ),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey, width: 0.3),
            ),
          ),
          child: ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            title:
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: role + "  ",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  /*  const WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(Icons.circle, size: 6, color: Colors.grey),
                    ),
                  ),*/
                  TextSpan(
                    text: age,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
