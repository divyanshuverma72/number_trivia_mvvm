import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionUtil {
  Future<bool> arePermissionsGranted();
  Future<bool> requestPermissions();
}

class PermissionUtilImpl extends PermissionUtil {
  @override
  Future<bool> arePermissionsGranted() async {
    /// Check if all permissions have been given
    var cameraStatus = await Permission.camera.status;
    var locationStatus = await Permission.location.status;
    if (locationStatus.isDenied ||
        cameraStatus.isDenied ||
        locationStatus.isPermanentlyDenied ||
        cameraStatus.isPermanentlyDenied) {
      /// Permissions are needed
      return false;
    } else {
      /// Permissions have been given
      return true;
    }
  }

  @override
  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
        Permission.location,
    ].request();

    if (statuses.isNotEmpty) {
      PermissionStatus? locationPermission = statuses[Permission.location];
      PermissionStatus? cameraPermission = statuses[Permission.camera];
      if (locationPermission == PermissionStatus.granted &&
          cameraPermission == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }
}