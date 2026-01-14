import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart'; // Import the flag package

class Step1 extends StatefulWidget {
  final Function(String) onDataChanged;
  Step1({required this.onDataChanged});
  @override
  _Step1State createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  String selectedLanguage = 'Arabic'; // Default language
  FixedExtentScrollController _scrollController = FixedExtentScrollController();

  final List<Map<String, String>> languages = [
    {
      'language': 'Arabic',
      'code': 'SA'
    }, // Use 'SA' for Arabic (Saudi Arabia flag)
    {'language': 'French', 'code': 'FR'}, // Use 'FR' for French (France flag)
    {'language': 'English', 'code': 'GB'}, // Use 'GB' for English (UK flag)
    {
      'language': 'Portuguese',
      'code': 'PT'
    }, // Use 'PT' for Portuguese (Portugal flag)
    {'language': 'Spanish', 'code': 'ES'}, // Use 'ES' for Spanish (Spain flag)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Container(
            margin: EdgeInsets.only(top: 40), // Add space from the top
            width: MediaQuery.of(context).size.width *
                0.6, // 60% of the screen width
            child: H2TITLE(
              'Choose your languages',
            ),
          ),
          SizedBox(height: 60), // Add some space between title and the rest

          // Centered content (List of languages)
          Center(
            child: Stack(
              children: [
                Container(
                  height: 150, // Set a fixed height for the scrollable area
                  width: 300, // Set width to fit the screen
                  child: ListWheelScrollView.useDelegate(
                    controller:
                        _scrollController, // Connect controller to ListWheelScrollView
                    itemExtent: 80,
                    physics: FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedLanguage = languages[index]['language']!;
                        widget.onDataChanged(selectedLanguage);
                        print(
                            'Tapped Language: $selectedLanguage'); // 👈 Print here
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedLanguage = languages[index]['language']!;
                              widget.onDataChanged(selectedLanguage);
                              print(
                                  'Tapped Language: $selectedLanguage'); // 👈 Print here

                              _scrollController
                                  .jumpToItem(index); // Jump to selected item
                            });
                          },
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the radius as needed
                                    child: Flag.fromCode(
                                      getFlagCode(
                                          languages[index]['language']!),
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  SizedBox(width: 24),
                                  Container(
                                    width: 200,
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      languages[index]['language']!,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: deepgrey),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: languages.length,
                    ),
                  ),
                ),
                // Top arrow button
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () {
                      int currentIndex = _scrollController.selectedItem;
                      widget
                          .onDataChanged(languages[currentIndex]['language']!);

                      if (currentIndex > 0) {
                        _scrollController
                            .jumpToItem(currentIndex - 1); // Scroll up
                      }
                    },
                  ),
                ),
                // Bottom arrow button
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: () {
                      int currentIndex = _scrollController.selectedItem;
                      widget
                          .onDataChanged(languages[currentIndex]['language']!);
                      print(
                          'Tapped Language: $selectedLanguage'); // 👈 Print here

                      if (currentIndex < languages.length - 1) {
                        _scrollController
                            .jumpToItem(currentIndex + 1); // Scroll down
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to return the appropriate FlagsCode based on the language
  FlagsCode getFlagCode(String language) {
    switch (language) {
      case 'Arabic':
        return FlagsCode.SA; // Saudi Arabia flag for Arabic
      case 'French':
        return FlagsCode.FR; // France flag for French
      case 'English':
        return FlagsCode.GB; // UK flag for English
      case 'Portuguese':
        return FlagsCode.PT; // Portugal flag for Portuguese
      case 'Spanish':
        return FlagsCode.ES; // Spain flag for Spanish
      default:
        return FlagsCode.GB; // Default to English flag
    }
  }
}
