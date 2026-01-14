import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/comunity/Profile_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  final String preferredFoot;

  Profile({required this.preferredFoot});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(preferredFoot: json['preferred_foot']);
  }
}

class Measurements {
  final double height;
  final double weight;
  final String heightUnit;
  final String weightUnit;

  Measurements({
    required this.height,
    required this.weight,
    required this.heightUnit,
    required this.weightUnit,
  });

  factory Measurements.fromJson(Map<String, dynamic> json) {
    return Measurements(
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      heightUnit: json['height_unit'],
      weightUnit: json['weight_unit'],
    );
  }
}

class PhysicalAttributesSection extends StatefulWidget {
  @override
  _PhysicalAttributesSectionState createState() =>
      _PhysicalAttributesSectionState();
}

class _PhysicalAttributesSectionState extends State<PhysicalAttributesSection> {
  late Future<Profile?> profileFuture;
  late Future<Measurements?> measurementsFuture;

  Future<Profile?> fetchProfile(int userId) async {
    try {
      final response = await http
          .get(Uri.parse('https://api.kickplayer.net/profile/$userId'));
      if (response.statusCode == 200) {
        return Profile.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  Future<Measurements?> fetchMeasurements(int userId) async {
    try {
      final response = await http
          .get(Uri.parse('https://api.kickplayer.net/measurements/$userId'));
      if (response.statusCode == 200) {
        return Measurements.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load measurements: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching measurements: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetch();
  }

  void _loadUserIdAndFetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = int.tryParse(prefs.getString('user_id') ?? '') ?? 15;
    setState(() {
      profileFuture = fetchProfile(userId);
      measurementsFuture = fetchMeasurements(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([profileFuture, measurementsFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('An unexpected error occurred.'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available.'));
          }

          final Profile? profile = snapshot.data![0] as Profile?;
          final Measurements? measurements = snapshot.data![1] as Measurements?;

          if (profile == null || measurements == null) {
            return Center(child: Text('Failed to load all user data.'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Physical Attributes',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: deepBlueColor),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PhysicalAttributes(
                    title: 'Height',
                    value: '${measurements.height} ${measurements.heightUnit}',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  PhysicalAttributes(
                    title: 'Weight',
                    value: '${measurements.weight} ${measurements.weightUnit}',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  PhysicalAttributes(
                    title: 'Foot',
                    value: profile.preferredFoot,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
