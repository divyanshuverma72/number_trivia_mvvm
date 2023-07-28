import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:number_trivia_mvvm/home/repository/home_repo.dart';
import 'package:number_trivia_mvvm/home/view_model/home_view_model.dart';
import 'package:number_trivia_mvvm/permissions/view/permissions_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'home/view/home_view.dart';
import 'locator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();

  var path = "/assets/db";
  if (!kIsWeb) {
    path = appDocumentDirectory.path;
  }

  await Hive.initFlutter(path);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => HomeViewModel(homeRepository: locator<HomeRepository>()),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          const /*PermissionsScreen() */ MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
