import 'dart:convert';
import 'dart:ui';

import 'package:Kaledal/presentation/comunity/post_details.dart';
import 'package:Kaledal/presentation/home/navbar.dart';
import 'package:Kaledal/presentation/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/comunity/community.dart';
import 'package:Kaledal/presentation/home/challenges.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlayerDashboard extends StatelessWidget {
  const PlayerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Dashbaord",
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuoteWidget(),
                const SizedBox(height: 24),

                TrendingPlayersWidget(),

                const SizedBox(height: 24),

                // Progress Section
                ChallengeProgressWidget(),

                const SizedBox(height: 24),

                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Challenges(),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset("assets/images/Frame 944.png"),
                    )),

                const SizedBox(height: 24),

                // Community Media
                CommunityMedia()
              ],
            ),
          ),
        ));
  }

  Widget _buildProgress(String label, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label),
              const Spacer(),
              Text("${(percent * 100).toInt()}%"),
            ],
          ),
          const SizedBox(height: 4),
          LinearPercentIndicator(
            lineHeight: 8,
            percent: percent,
            backgroundColor: Colors.grey.shade300,
            progressColor: color,
            barRadius: const Radius.circular(10),
          ),
        ],
      ),
    );
  }
}

class TrendingPlayersWidget extends StatefulWidget {
  const TrendingPlayersWidget({Key? key}) : super(key: key);

  @override
  State<TrendingPlayersWidget> createState() => _TrendingPlayersWidgetState();
}

class _TrendingPlayersWidgetState extends State<TrendingPlayersWidget> {
  List<dynamic> players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrendingPlayers();
  }

  Future<void> fetchTrendingPlayers() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.kickplayer.net/trending-players'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          players = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load players');
      }
    } catch (e) {
      print("Error fetching players: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Trending Players",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: players.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final player = players[index];
                    final imageUrl = player['profile_picture'] ??
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqafzhnwwYzuOTjTlaYMeQ7hxQLy_Wq8dnQg&s';
                    final name = player['full_name'] ?? 'Unknown';
                    final position = player['position'] ?? 'N/A';
                    final age = player['age']?.toString() ?? 'N/A';

                    return Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2632FF), Color(0xFF000066)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Image with top border radius
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 45),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),

                          // Text container with top shadow
                          Positioned(
                              bottom: 70,
                              left: 0,
                              right: 0,
                              child:
                                  // New Container with Gradient
                                  Container(
                                height: 20, // Height of the gradient container
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xFF000066),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              )),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 70,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFF000066),
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Position and Age in a row
                                  Row(
                                    children: [
                                      Text(
                                        position,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        age,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class ChallengeProgressWidget extends StatefulWidget {
  const ChallengeProgressWidget({Key? key}) : super(key: key);

  @override
  State<ChallengeProgressWidget> createState() =>
      _ChallengeProgressWidgetState();
}

class _ChallengeProgressWidgetState extends State<ChallengeProgressWidget> {
  double totalCompleted = 0;
  double totalChallenges = 0;
  double overallPercentage = 0;
  List<dynamic> categories = [];
  bool isLoading = true;

  final Map<String, Color> categoryColors = {
    "Passing": Colors.red,
    "Defending": Colors.orange,
    "Attacking": Colors.green,
    "Shooting": Colors.purple,
    "Dribbling": Colors.blue,
    "Pace": Colors.teal,
    "Physicality": Colors.brown,
  };

  @override
  void initState() {
    super.initState();
    fetchProgress();
  }

  Future<void> fetchProgress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      // If userId is null, we can't proceed with the API call
      if (userId == null) {
        throw "User ID is missing";
      }

      final response = await http.get(
        Uri.parse(
            'https://api.kickplayer.net/players/$userId/challenge-progress'),
        headers: {'accept': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Handling data conversion
        setState(() {
          totalCompleted =
              double.tryParse(data['total_completed'].toString()) ?? 0.0;
          totalChallenges =
              double.tryParse(data['total_challenges'].toString()) ?? 0.0;
          overallPercentage =
              double.tryParse(data['overall_percentage'].toString()) ?? 0.0;
          categories = data['categories'] ?? [];
          isLoading = false;
        });
      } else {
        throw "Failed to load challenge progress";
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
      print("Error fetching progress: $e");
    }
  }

  Widget _buildProgress(String title, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text("${(percent * 100).toInt()}%",
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade300,
              color: color,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 252, 251, 251),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Your Challenges Progress",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text("Completed Challenges",
                    style: TextStyle(
                        color: Color(0xFF5E6C84),
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${totalCompleted.toStringAsFixed(0)}/${totalChallenges.toStringAsFixed(0)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                    CircularPercentIndicator(
                      radius: 30,
                      percent: overallPercentage / 100,
                      progressColor: mainblue,
                      center: Text("${overallPercentage.toStringAsFixed(0)}%",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: mainblue)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...categories.map((cat) => _buildProgress(
                      cat['name'],
                      (cat['percentage'] ?? 0) / 100,
                      categoryColors[cat['name']] ?? Colors.blue,
                    )),
              ],
            ),
          );
  }
}

class CommunityMedia extends StatefulWidget {
  const CommunityMedia({Key? key}) : super(key: key);

  @override
  State<CommunityMedia> createState() => _CommunityMediaState();
}

class _CommunityMediaState extends State<CommunityMedia> {
  List<dynamic> mediaItems = [];
  bool isLoading = true;
  bool hasError = false; // Track if there's an error

  @override
  void initState() {
    super.initState();
    fetchMedia();
  }

  Future<void> fetchMedia() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.kickplayer.net/posts/recent-media?limit=10'),
      );

      if (response.statusCode == 200) {
        setState(() {
          mediaItems = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        // Handle API errors
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      // Handle errors (like network issues)
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Community media",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(initialIndex: 1),
                    ),
                  );
                },
                child:
                    Text("View all", style: TextStyle(color: deepBlueColor))),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
                  ? const Center(child: Text('Error loading media.'))
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: mediaItems.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final item = mediaItems[index];

                        final ID = item['post_id'] ?? '';
                        final thumbnailUrl = item['thumbnail_url'] ?? '';
                        final media_url = item['media_url'] ?? '';
                        final creatorName = item['creator_name'] ?? 'Unknown';
                        final isImage =
                            media_url.toLowerCase().endsWith('.png') ||
                                media_url.toLowerCase().endsWith('.jpg');
                        final displayImage = isImage ? media_url : thumbnailUrl;
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostWithCommentsPage(
                                    postId: item['post_id'],
                                    avatarUrl: item['avatar_url'] ??
                                        '', // Provide default if needed
                                    userName: item['creator_name'] ?? 'Unknown',
                                    postTime: item['created_at'] ??
                                        '', // e.g., '2h ago'
                                    postText: item['post_text'] ?? '',
                                    postMediaUrl: media_url,
                                    Topic: item['topic'] ?? '',
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(displayImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black54,
                                            Colors.transparent
                                          ],
                                        ),
                                      ),
                                      child: Text(
                                        creatorName,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  /* Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.grey[700]?.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 5, sigmaY: 5),
                                          child: Container(
                                            color: Colors.black.withOpacity(0),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.arrow_upward,
                                                    size: 12,
                                                    color: Colors.white),
                                                SizedBox(width: 4),
                                                Text("20M",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),*/
                                ],
                              ),
                            ));
                      },
                    ),
        ),
      ],
    );
  }
}

class QuoteWidget extends StatefulWidget {
  const QuoteWidget({Key? key}) : super(key: key);

  @override
  State<QuoteWidget> createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  String quote = "Loading...";
  String author = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkStoredQuote();
  }

  Future<void> checkStoredQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString('quoteDate');
    final today = DateTime.now().toIso8601String().split('T').first;

    if (storedDate == today && prefs.containsKey('quote')) {
      // Use stored quote
      setState(() {
        quote = prefs.getString('quote')!;
        author = prefs.getString('author')!;
        isLoading = false;
      });
    } else {
      // Fetch new quote
      await fetchQuote();
    }
  }

  Future<void> fetchQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.kickplayer.net/quote'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newQuote = data['quote'] ?? "No quote available";
        final newAuthor = data['author'] ?? "Unknown";

        final prefs = await SharedPreferences.getInstance();
        final today = DateTime.now().toIso8601String().split('T').first;

        // Store quote and today's date
        await prefs.setString('quote', newQuote);
        await prefs.setString('author', newAuthor);
        await prefs.setString('quoteDate', today);

        setState(() {
          quote = newQuote;
          author = newAuthor;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          quote = "Failed to load quote";
          author = "Unknown";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        quote = "Error fetching quote";
        author = "Unknown";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote, color: Colors.blue, size: 30),
                const SizedBox(height: 8),
                Text(
                  "\"$quote\"",
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
