import 'package:flutter/material.dart';
import 'package:number_trivia_mvvm/util/permission_util.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../home/view/home_view.dart';

class PermissionsViewModel {
  
  PermissionUtil permissionUtil;
  PermissionsViewModel({required this.permissionUtil});

  Future<bool> allPermissionsGranted() async {
    /// Check if all permissions have been given
    return await permissionUtil.arePermissionsGranted();
  }

  Future<bool> requestPermissions() async {
    /// Check if all permissions have been given
    return await permissionUtil.requestPermissions();
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement (
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}
