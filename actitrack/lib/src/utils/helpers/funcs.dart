import 'dart:math' as math;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toastification/toastification.dart';

abstract class FuncHelpers {
  static Future<void> errorVibrate() async {
    for (var i = 0; i < 2; i++) {
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  static Size getDeviceSize(BuildContext context) =>
      MediaQuery.of(context).size;

  /// calcualte the distance between two points and return the distance in meters
  static double calculateDistanceBetweenTwoPoints(LatLng from, LatLng to,
      {bool km = false}) {
    double distance = Geolocator.distanceBetween(
        from.latitude, from.longitude, to.latitude, to.longitude);
    if (km) {
      distance = distance / 1000;
    }
    return distance;
  }

  static double calculateTotalDistance(List<LatLng> coordinates,
      {bool km = false}) {
    double totalDistance = 0.0;

    if (coordinates.length < 2) {
      return totalDistance;
    }

    for (int i = 0; i < coordinates.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        coordinates[i].latitude,
        coordinates[i].longitude,
        coordinates[i + 1].latitude,
        coordinates[i + 1].longitude,
      );
    }

    if (km) {
      totalDistance = totalDistance / 1000;
    }

    return totalDistance;
  }

  static LatLng calculateCoordsCenter(List<LatLng> locations) {
    double totalLat = 0.0;
    double totalLng = 0.0;

    for (LatLng location in locations) {
      totalLat += location.latitude;
      totalLng += location.longitude;
    }

    double centerLat = totalLat / locations.length;
    double centerLng = totalLng / locations.length;

    return LatLng(centerLat, centerLng);
  }

  static Future<bool> checkIfOnline() async {
    try {
      final ConnectivityResult res = await Connectivity().checkConnectivity();
      final isOnline =
          res == ConnectivityResult.wifi || res == ConnectivityResult.mobile;
      return isOnline;
    } catch (e) {
      return false;
    }
  }

  static showToastNotification({
    ToastificationType notiType = ToastificationType.success,
    bool noWifi = false,
    required String title,
    String? description,
  }) {
    Icon icon;
    if (noWifi) {
      icon = Icon(Icons.wifi_off);
    } else {
      switch (notiType) {
        case ToastificationType.info:
          icon = Icon(Icons.info);
          break;
        case ToastificationType.success:
          icon = Icon(Icons.check);
          break;
        case ToastificationType.warning:
          icon = Icon(Icons.warning);
          break;
        case ToastificationType.error:
          icon = Icon(Icons.error);
          break;
      }
    }
    toastification.show(
      type: notiType,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title),
      description: description != null
          ? RichText(
              text: TextSpan(
                  text: description,
                  style: TextStyle(
                    color: Colors.black,
                  )),
            )
          : null,
      alignment: Alignment.bottomCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: icon,
      primaryColor: const Color.fromARGB(255, 0, 0, 0),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: false,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => MyLogger.info('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            MyLogger.info('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            MyLogger.info('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) =>
            MyLogger.info('Toast ${toastItem.id} dismissed'),
      ),
    );
  }
}
