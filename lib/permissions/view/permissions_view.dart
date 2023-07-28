import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../locator.dart';
import '../view_model/permissions_view_model.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => PermissionsScreenState();
}

class PermissionsScreenState extends State<PermissionsScreen> {

  PermissionsViewModel permissionsViewModel = PermissionsViewModel(permissionUtil: locator());
  String inputStr = "";

  @override
  void initState() {
    super.initState();
    permissionsViewModel = Provider.of<PermissionsViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool permissionGranted = await permissionsViewModel.allPermissionsGranted();
      if (permissionGranted) {
        permissionsViewModel.navigateToHomeScreen(context);
      } else {
        bool permissionGrantedAfterRequest = await permissionsViewModel.requestPermissions();
        if (permissionGrantedAfterRequest) {
          permissionsViewModel.navigateToHomeScreen(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}