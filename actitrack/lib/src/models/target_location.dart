import 'package:actitrack/src/models/distribution_object.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TargetLocation {
  int? id;
  String? name;
  final LatLng coordinates;
  final bool deliveryCompleted;
  List<DistributionObject> distributionObjects;
  DistributionObject? Selectedobject;
  TargetLocation({
    this.id,
    required this.coordinates,
    this.name,
    this.deliveryCompleted = false,
    this.distributionObjects = const [],
    this.Selectedobject,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'delivery_completed': deliveryCompleted,
    };
  }

  factory TargetLocation.fromJson(Map<String, dynamic> json) {
    List<DistributionObject> inDistributionObjects = [];
    if (json['distributionObjects'] != null) {
      for (var object in json['distributionObjects']) {
        inDistributionObjects.add(DistributionObject.fromJson(object));
      }
    }
    MyLogger.info(json);
    return TargetLocation(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      deliveryCompleted: json['status'] == 'success',
      coordinates: LatLng(
        double.tryParse(json['latitude']) ?? 0.0,
        double.tryParse(json['longitude']) ?? 0.0,
        /*37.4319083,
          -122.084*/
      ),
      distributionObjects: inDistributionObjects,
    );
  }

  copyWith({
    int? id,
    String? name,
    LatLng? coordinates,
    bool? deliveryCompleted,
  }) {
    return TargetLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      coordinates: coordinates ?? this.coordinates,
      deliveryCompleted: deliveryCompleted ?? this.deliveryCompleted,
    );
  }

  @override
  String toString() {
    return 'TargetLocation(name: $name, coordinates: (${coordinates.latitude}, ${coordinates.longitude}))';
  }
}
