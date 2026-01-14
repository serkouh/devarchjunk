import 'package:flutter/material.dart';
import 'package:Kaledal/presentation/home/record_challenge.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Challenges extends StatefulWidget {
  @override
  _ChallengesState createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  //2 3 9
  final List<Map<String, String>> items = [
    {
      'image': 'assets/challenges/00000.png',
      'title': 'Juggling ',
      'buttonText': 'Button 1',
      'subtitle': 'Subtitle 1',
      "options": "Dribbling",
      "id": "16",
    },
    {
      'image': 'assets/challenges/Frame 380.png',
      'title': 'Sprint to Success',
      'buttonText': 'Button 2',
      'subtitle': 'Subtitle 2',
      "options": "Pace",
      "id": "9",
    },
    {
      'image': 'assets/challenges/Frame 388.png',
      'title': 'Penalty Decision',
      'buttonText': 'Button 1',
      'subtitle': 'Subtitle 1',
      "options": "Shooting",
      "id": "12",
    },
    {
      'image': 'assets/challenges/Frame 389.png',
      'title': 'Volley Decision',
      'buttonText': 'Button 2',
      'subtitle': 'Subtitle 2',
      "options": "Shooting",
      "id": "13",
    },
    {
      'image': 'assets/challenges/Frame 390.png',
      'title': 'Long Pass Decision',
      'buttonText': 'Button 1',
      'subtitle': 'Subtitle 1',
      "options": "Passing",
      "id": "3",
    },
    {
      'image': 'assets/challenges/Frame 391.png',
      'title': 'Crossing Challenge',
      'buttonText': 'Button 2',
      'subtitle': 'Subtitle 2',
      "options": "Passing",
      "id": "2",
    },
    {
      'image': 'assets/challenges/Frame 392.png',
      'title': 'Short Pass Drill ',
      'buttonText': 'Button 1',
      'subtitle': 'Subtitle 1',
      "options": "Passing",
      "id": "1",
    },
    {
      'image': 'assets/challenges/Frame 386.png',
      'title': '15m Dribbling with Run',
      'buttonText': 'Button 2',
      'subtitle': 'Subtitle 2',
      "options": "Dribbling",
      "id": "15",
    },
    {
      'image': 'assets/challenges/Frame 394.png',
      'title': 'Zigzag Dash',
      'buttonText': 'Button 1',
      'subtitle': 'Subtitle 1',
      "options": "Dribbling",
      "id": "11",
    },
    {
      'image': 'assets/challenges/Frame 395.png',
      'title': 'Strength Hold',
      'buttonText': 'Button 2',
      'subtitle': 'Subtitle 2',
      "options": "Physicality",
      "id": "6",
    },
    {
      'image': 'assets/challenges/Frame 398.png',
      'title': 'Vertical Leap Test ',
      'buttonText': 'Button 1',
      'subtitle': 'Subtitle 1',
      "options": "Physicality",
      "id": "8",
    },
    {
      'image': 'assets/challenges/Frame 399.png',
      'title': 'Endurance Sprint',
      'buttonText': 'Button 2',
      'subtitle': 'Subtitle 2',
      "options": "Physicality",
      "id": "7",
    },
    {
      'image': 'assets/challenges/Frame 387.png',
      'title': 'Power Shoot Test',
      'buttonText': 'Button 1',
      'subtitle': 'Subtitle 1',
      "options": "Shooting",
      "id": "14",
    },
    {
      'image': 'assets/challenges/Frame 397.png',
      'title': 'Interception Zone',
      'buttonText': 'Button 2',
      'subtitle': 'Subtitle 2',
      "options": "Defending",
      "id": "4",
    },
    /*{
      'image': 'assets/challenges/Frame 890.png',
      'title': 'Long Pass Decision',
      'buttonText': 'Button 2',
      'subtitle': 'Subtitle 2',
      "options": "Dribbling",
      "id": "3",
    },*/
  ];

  final List<Map<String, String>> options = [
    {'label': 'All'}, // No image for "All"
    {'image': 'assets/images/Group (1).png', 'label': 'Passing'},
    {'image': 'assets/images/Vector (3).png', 'label': 'Defending'},
    {'image': 'assets/images/Vector (4).png', 'label': 'Physicality'},
    {'image': 'assets/images/Vector (5).png', 'label': 'Pace'},
    {'image': 'assets/images/Group (2).png', 'label': 'Dribbling'},
    {'image': 'assets/images/Vector (2).png', 'label': 'Shooting'},
  ];

  String selectedOption = 'All';

  @override
  Widget build(BuildContext context) {
    items.sort((a, b) => int.parse(a['id']!).compareTo(int.parse(b['id']!)));
    final filteredItems = selectedOption == 'All'
        ? items
        : items.where((item) => item['options'] == selectedOption).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'AI Powered Challenges',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00326C),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: options.map((option) {
                      bool isSelected = option['label'] == selectedOption;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOption = option['label']!;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? Color(0xFF00326C) : Colors.white,
                              border: Border.all(color: Color(0xFF00326C)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(6),
                            child: Row(
                              children: [
                                if (option.containsKey(
                                    'image')) // Only show image if it exists
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Image.asset(
                                      option['image']!,
                                      width: 10,
                                      height: 10,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                Text(
                                  option['label']!,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Color(0xFF00326C),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Divider(color: Color(0xFF00326C), thickness: 1),
              ...filteredItems.map((item) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoRecord(
                            videoTitle: item['id'] ?? '0',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 170,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                item['image']!,
                                width: MediaQuery.of(context).size.width,
                                height: 150,
                                fit: BoxFit.fill,
                              ),
                            ),
                            /* Positioned(
                              top: 5,
                              left: -5,
                              child: Column(
                                children: [
                                  Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.white),
                                    ),
                                    padding: EdgeInsets.all(6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          item['subtitle']!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 50),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              100,
                                          child: AutoSizeText(
                                            item['title']!,
                                            style: TextStyle(
                                              color: Color(0xFF00326C),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines:
                                                2, // Ensures that text doesn't exceed 2 lines
                                            overflow: TextOverflow
                                                .ellipsis, // Adds ellipsis if text exceeds the available space
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          height: 25,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFF5722),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: TextButton(
                                            onPressed: () {},
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets
                                                  .zero, // Removes any padding
                                              minimumSize: Size
                                                  .zero, // Prevents any default minimum size
                                              tapTargetSize: MaterialTapTargetSize
                                                  .shrinkWrap, // Shrinks the tap target to the content size
                                            ),
                                            child: Text(
                                              "Start",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ));
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
