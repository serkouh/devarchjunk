import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Future<bool> requestStoragePermission() async {
    return await _requestPermission(Permission.storage);
  }

  Future<bool> requestLocationPermission() async {
    return await _requestPermission(Permission.location);
  }

  Future<bool> requestCameraPermission() async {
    return await _requestPermission(Permission.camera);
  }

  Future<bool> _requestPermission(Permission permission) async {
    try {
      var status = await permission.status;
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        final result = await permission.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      }
    } catch (e) {
      MyLogger.error(
          'Error requesting $permission permission: ${e.toString()}');
    }
    return false;
  }
}
