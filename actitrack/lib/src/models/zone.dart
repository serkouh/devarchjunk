import 'package:google_maps_flutter/google_maps_flutter.dart';

class Zone {
  int id;
  String name;
  String? code;
  List<LatLng> locations;

  Zone({
    required this.id,
    required this.name,
    this.code,
    this.locations = const [],
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        locations: List.from(json['locations'])
            .map(
              (l) => LatLng(
                double.parse(l['latitude']),
                double.parse(l['longitude']),
              ),
            )
            .toList());
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'code': code,
  //   };
  // }
}
