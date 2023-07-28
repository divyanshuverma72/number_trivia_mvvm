import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:number_trivia_mvvm/util/hive_util.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  late NumberTriviaHiveUtilImpl numberTriviaHiveUtilImpl;

  setUp(() {
    numberTriviaHiveUtilImpl = NumberTriviaHiveUtilImpl();
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    return ".";
  });

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);

  test("Check if the values are getting stored in the Hive db correctly", () async {
    // arrange
    await numberTriviaHiveUtilImpl.writeToHiveDb("TriviaCache");

    //act
    final value = await numberTriviaHiveUtilImpl.readFromHive();

    //assert
    expect("TriviaCache", value);
  });

  test("should return null if the data is null", () async {
    // arrange
    Box box = await Hive.openBox(cachedNumberTriviaBox);
    box.delete(cachedNumberTriviaKey);
    //act
    final value = await numberTriviaHiveUtilImpl.readFromHive();

    //assert
    expect(null, value);
  });
}