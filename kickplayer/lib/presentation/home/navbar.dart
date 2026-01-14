import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/academy/acamdemy_homee.dart';
import 'package:Kaledal/presentation/academy/dashbaord.dart';
import 'package:Kaledal/presentation/chats/allchat.dart';
import 'package:Kaledal/presentation/comunity/community.dart';
import 'package:Kaledal/presentation/comunity/posts.dart';
import 'package:Kaledal/presentation/home/challenges.dart';
import 'package:Kaledal/presentation/home/players.dart';

class HomeScreen extends StatefulWidget {
  final int? initialIndex;

  const HomeScreen({Key? key, this.initialIndex}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    PlayerDashboard(),
    CommunityPage(),
    VirtualAcademyPage(),
    MessagesScreen(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0; // Default to 0 if null
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _pages[_selectedIndex], // Display the selected page
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: Colors.grey, width: 1), // Bordure grise en haut
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white, // Barre blanche
            selectedItemColor: mainblue, // Sélection en bleu
            unselectedItemColor: deepBlueColor, // Non sélection en gris
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(fontSize: 1),
            unselectedLabelStyle: TextStyle(fontSize: 1),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/home.png',
                  width: 30,
                  height: 30,
                  color: _selectedIndex == 0 ? mainblue : deepBlueColor,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/users-group-rounded-svgrepo-com.png',
                  width: 30,
                  height: 30,
                  color: _selectedIndex == 1 ? mainblue : deepBlueColor,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/educare-(ekt).png',
                  width: 30,
                  height: 30,
                  color: _selectedIndex == 2 ? mainblue : deepBlueColor,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/messages icon.png',
                  width: 30,
                  height: 30,
                  color: _selectedIndex == 3 ? mainblue : deepBlueColor,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/user-circle-svgrepo-com.png',
                  width: 30,
                  height: 30,
                  color: _selectedIndex == 4 ? mainblue : deepBlueColor,
                ),
                label: '',
              ),
            ],
          ),
        ));
  }
}
