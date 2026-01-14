import 'dart:convert';

import 'package:actitrack/src/models/zone.dart';
import 'package:actitrack/src/services/http_client.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'target_location.dart';

class Task {
  int? id;
  Zone? zone;
  String? name;
  String? description;
  int? zoneId;
  String? startLocation;
  String? endLocation;
  int? animatorId;
  List<TargetLocation>? locations;
  int? flyersCount;
  int? flyersLeft;
  int flyersDistributed;
  DateTime? startDate;
  DateTime? endDate;
  String? status;

  Task({
    this.id,
    this.name,
    this.zone,
    this.description,
    this.zoneId,
    this.startLocation,
    this.endLocation,
    this.animatorId,
    this.locations,
    this.flyersCount,
    this.flyersLeft,
    required this.flyersDistributed,
    this.startDate,
    this.endDate,
    this.status,
  });

  List<LatLng> get coordinates =>
      (locations ?? []).map((location) => location.coordinates).toList();
  bool get isCancelled => status == 'closed';
  bool get isCompleted => status == 'success';
  bool get isToday =>
      startDate.toString().contains(DateTime.now().toString().substring(0, 10));
  //startDate!.isBefore(DateTime.now()) && endDate!.isAfter(DateTime.now());
  bool get isTomorrow =>
      startDate!.isAfter(DateTime.now()) &&
      startDate!.isBefore(DateTime.now().add(const Duration(days: 1)));

  factory Task.fromJson(Map<String, dynamic> json) {
    // List<TargetLocation> taskLocations = [];
    // for (var locationData in json['locations']) {
    //   taskLocations.add(TargetLocation.fromJson(locationData));
    // }
    getGoodDate(date) {
      // DateTime parsedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss:SSSSSS.SSS").parse(date);
      DateTime parsedDate = DateTime.parse(date.toString());
      return parsedDate;
    }

    return Task(
      id: json['task']['id'],
      name: json['task']['name'],
      description: json['task']['description'],
      // zoneId: json['zone_id'],
      // startLocation: json['start_location'],
      // endLocation: json['end_location'],
      // animatorId: json['animator_id'],
      // locations: taskLocations,
      flyersCount: json['totalTaskDistrubutionObjects'],
      flyersLeft: json['totalObjectLeft'],
      flyersDistributed: json['distributedObjectCount'],
      startDate: getGoodDate(json['task']['start_date']),
      endDate: getGoodDate(json['task']['end_date']),
      status: json['task']['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'zone_id': zoneId,
      'start_location': startLocation,
      'end_location': endLocation,
      'animator_id': animatorId,
      'locations': locations,
      'flyers_count': flyersCount,
      'flyers_left': flyersLeft,
      'flyers_distributed': flyersDistributed,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
    };
  }
}
