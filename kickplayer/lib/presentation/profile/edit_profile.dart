import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  int _selectedTabIndex = 0; // Variable to track the selected tab index

  final List<String> tabs = ['Personal Info', 'Career Info', 'Medical Info'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: deepBlueColor),
          onPressed: () {},
        ),
        title: Text(
          "Personal Information",
          style: TextStyle(fontSize: 18, color: deepBlueColor),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.search, color: mainblue),
          SizedBox(width: 12),
          Icon(Icons.more_vert, color: mainblue),
          SizedBox(width: 8),
        ],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: deepgrey, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with banner and avatar
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://www.fcbarcelona.com/photo-resources/2024/10/03/cebce9b3-4e65-4923-a20f-488882e064c7/EA019746.jpg?width=1200&height=750',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 24),
                ),
                Positioned(
                  bottom: -45,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 3),
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 47,
                          backgroundImage:
                              AssetImage('assets/images/player_photo.jpg'),
                        ),
                      ),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt, size: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // 🔹 Tab Buttons (Using _buildTab method)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 16),
                Expanded(child: _buildTab('Info', 0)),
                SizedBox(width: 16),
                Expanded(child: _buildTab('Attributes', 1)),
                SizedBox(width: 16),
                Expanded(child: _buildTab('Others', 2)),
                SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Tab Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _selectedTabIndex == 0
                  ? _buildPersonalInfo()
                  : _selectedTabIndex == 1
                      ? _buildCareerInfo()
                      : _buildMedicalInfo(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index; // Update the selected tab index
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: _selectedTabIndex == index
              ? mainblue
              : Colors.white, // Change color on selection
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: mainblue),
        ),
        child: Center(
          child: AutoSizeText(
            title,
            maxLines: 1, // Ensure the text stays in one line
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _selectedTabIndex == index ? Colors.white : mainblue,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for displaying the profile info
  Widget _buildPersonalInfo() {
    return Column(
      children: [
        InputField(
            label: 'Full Name',
            icon: Icons.person,
            hintText: 'Ahmed Alami',
            keyboardType: TextInputType.text),
        SizedBox(height: 12),
        InputField(
            label: 'Date Of Birth',
            icon: Icons.calendar_today,
            hintText: '23-10-2000',
            keyboardType: TextInputType.datetime),
        SizedBox(height: 12),
        InputField(
            label: 'Nationality',
            icon: Icons.flag,
            hintText: 'Morocco',
            keyboardType: TextInputType.text,
            enabled: false),
        SizedBox(height: 12),
        InputField(
            label: 'Phone',
            icon: Icons.phone,
            hintText: '123-456-7890',
            keyboardType: TextInputType.phone),
        SizedBox(height: 12),
        InputField(
            label: 'Address',
            icon: Icons.home,
            hintText: '123 Main Street, City, Country',
            keyboardType: TextInputType.text),
      ],
    );
  }

  Widget _buildCareerInfo() {
    return Column(
      children: [
        InputField(
            label: 'Team',
            icon: Icons.sports_soccer,
            hintText: 'ASSAD FC',
            keyboardType: TextInputType.text),
        SizedBox(height: 12),
        InputField(
            label: 'Division',
            icon: Icons.emoji_events,
            hintText: 'Amateur League 1',
            keyboardType: TextInputType.text),
        SizedBox(height: 12),
        InputField(
            label: 'Country',
            icon: Icons.map,
            hintText: 'Morocco',
            keyboardType: TextInputType.text,
            enabled: false),
        SizedBox(height: 12),
        InputField(
            label: 'League',
            icon: Icons.sports,
            hintText: 'Premier League',
            keyboardType: TextInputType.text),
        SizedBox(height: 12),
        InputField(
            label: 'MVP',
            icon: Icons.star,
            hintText: 'Yes',
            keyboardType: TextInputType.text),
      ],
    );
  }

  Widget _buildMedicalInfo() {
    return Column(
      children: [
        InputField(
            label: 'Wrist Size',
            icon: Icons.access_alarm,
            hintText: '7.5 inches',
            keyboardType: TextInputType.text),
        SizedBox(height: 12),
        InputField(
            label: 'Height',
            icon: Icons.height,
            hintText: '180 cm',
            keyboardType: TextInputType.number),
        SizedBox(height: 12),
        InputField(
            label: 'Weight',
            icon: Icons.line_weight,
            hintText: '75 kg',
            keyboardType: TextInputType.number),
        SizedBox(height: 12),
        InputField(
            label: 'Size',
            icon: Icons.aspect_ratio,
            hintText: 'L',
            keyboardType: TextInputType.text),
      ],
    );
  }
}
