import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:country_flags/country_flags.dart';

class PowerShotResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 0),
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue, width: 1.5),
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                child: const Text("View Profile"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                child: const Text(
                  "Play Again",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF2066C0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF161731), Color(0xFF2066C0)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      top: 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Pace',
                            style: TextStyle(
                              color: mainblue,
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            '250/400',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 0,
                      child: Image.asset(
                        'assets/images/PLAYER 2.png',
                        height: 190,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),

              // Test Results
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Test Result",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                        "Max. speed", "5.98 m/sec", 0.85, Colors.green),
                    _buildStatRow(
                        "Sprint time 10 m", "2.01 sec", 1.0, Colors.green),
                    _buildStatRow(
                        "Sprint time 15 m", "2.82 sec", 0.45, Colors.orange),
                    _buildStatRow(
                        "Starting speed", "4.62 m/sec", 0.25, Colors.red),
                    _buildStatRow("Feet Speed", "38 unit.", 0.95, Colors.green),
                  ],
                ),
              ),

              // Ranking List
              Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your Ranking",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Text(
                              "View all",
                              style: TextStyle(color: mainblue, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      _buildRankingItem(
                        rank: 1,
                        name: "John Doe",
                        role: "Defender",
                        points: "1023 pts",
                        countryCode: "CU", // Cuba
                        avatar: "assets/images/avatar1.png",
                        color: mainblue,
                      ),
                      _buildRankingItem(
                        rank: 2,
                        name: "Ahmed Salim",
                        role: "Striker",
                        points: "1012 pts",
                        countryCode: "MA", // Morocco
                        avatar: "assets/images/avatar2.png",
                        color: deepBlueColor,
                      ),
                      _buildRankingItem(
                          rank: 3,
                          name: "John Doe",
                          role: "Midfielder",
                          points: "922 pts",
                          countryCode: "GE", // Georgia
                          avatar: "assets/images/avatar3.png",
                          color: mainblue),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  )),
              // Buttons
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(
      String label, String value, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              color: color,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRankingItem({
    required int rank,
    required String name,
    required String role,
    required String points,
    required String countryCode,
    required String avatar,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Text(
            "$rank",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(avatar),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CountryFlag.fromCountryCode(
                      countryCode,
                      height: 16,
                      width: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Text(
                  role,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          /* Text(
            points,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          )*/
        ],
      ),
    );
  }
}
