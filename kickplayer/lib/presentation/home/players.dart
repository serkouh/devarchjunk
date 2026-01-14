import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';

class Players extends StatefulWidget {
  @override
  _PlayersState createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  final List<Map<String, String>> players = [
    {
      'avatar': 'assets/images/PLAYER 2.png',
      'name': 'Lionel Messi',
      'score': '98 pts',
      'nationality': 'ar',
      'age': '36',
      'league': 'MLS',
    },
    {
      'avatar': 'assets/images/PLAYER 2.png',
      'name': 'Cristiano Ronaldo',
      'score': '96 pts',
      'nationality': 'ma',
      'age': '39',
      'league': 'Saudi Pro League',
    },
    {
      'avatar': 'assets/images/PLAYER 2.png',
      'name': 'Kylian Mbappé',
      'score': '94 pts',
      'nationality': 'fr',
      'age': '25',
      'league': 'Ligue 1',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Players',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00326C),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                // First Section (30% width)
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF3A95FF),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 30,
                                          backgroundImage:
                                              AssetImage(player['avatar']!),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          player['name']!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          player['score']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2489FF),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                            width: 85,
                                                            child: Text(
                                                              "Nationality",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                        SizedBox(width: 8),
                                                        Flag.fromString(
                                                          player[
                                                              'nationality']!, // Utilise le code pays ISO (ex: "FR", "US")
                                                          height: 20,
                                                          width: 30,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(children: [
                                                      Container(
                                                          width: 80,
                                                          child: Text(
                                                            'Age:',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                      Text(
                                                        '${player['age']}',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ]),
                                                    SizedBox(height: 8),
                                                  ],
                                                ),
                                              ),
                                              Chip(
                                                label: Text(
                                                  'Top Player',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor:
                                                    Color(0xFFB04001),
                                                padding: EdgeInsets
                                                    .zero, // Supprime tout padding interne
                                                labelPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: -2),
                                              ),
                                            ]),
                                        Row(children: [
                                          Container(
                                              width: 80,
                                              child: Text(
                                                'League: ',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              )),
                                          Text(
                                            '${player['league']}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          )
                                        ]),
                                        SizedBox(height: 8),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: _buildActionButton(
                                                    Icons.monetization_on,
                                                    'Invest In',
                                                    deepBlueColor,
                                                    () {})),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                                child: _buildActionButton(
                                                    Icons.check_circle,
                                                    'Available',
                                                    deepBlueColor,
                                                    () {})),
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                        ),
                                        Container(
                                            width: double.infinity,
                                            height: 40,
                                            child: _buildActionButton(
                                                Icons.sports_soccer,
                                                'Versatile Right Winger',
                                                deepBlueColor,
                                                () {})),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return /*Expanded(
      child:*/
        ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: Colors.white), // White icon color
      label: Text(label, style: TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      // ),
    );
  }
}
