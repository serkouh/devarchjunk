import 'package:actitrack/src/services/permissions/permissions_service.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' show Location;

class LocationService {
  final Location _location = Location();
  final PermissionsService _permissionsService =
      serviceLocator<PermissionsService>();

  Location get location => _location;

  Future<Position?> getCurrentPosition() async {
    bool permissionGranted =
        await _permissionsService.requestLocationPermission();
    if (!permissionGranted) {
      MyLogger.info('Location permission denied');
      FuncHelpers.showToastNotification(
        title: "Autorisation requise",
        description:
            "l'application a besoin de votre autorisation pour accéder à la localisation",
      );
      return null;
    }

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      MyLogger.info('Location services are disabled');
      FuncHelpers.showToastNotification(
        title: "Location disabaled",
        description: "Location services are disabled",
      );
      return null;
    }

    // Get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      FuncHelpers.showToastNotification(
        title: "Error",
        description: "Error getting current location: $e",
      );
      MyLogger.info('Error getting current location: $e');
      return null;
    }
  }

  // Future<void> _promptEnableLocationServices() async {
  //   print('Please enable location services.');
  //   await Geolocator.openLocationSettings();
  // }
}
