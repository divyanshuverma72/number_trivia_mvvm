import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_mvvm/util/shared_preference_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferenceUtil sharedPreferenceUtil;

  setUp(() {
    // We can mock the values like this also for shared preferences
    SharedPreferences.setMockInitialValues({"three" : "3"});
    sharedPreferenceUtil = SharedPreferenceUtil.instance;
  });

  test("Check if the values are getting stored in the SharedPreferences correctly", () async {
    // arrange
    await sharedPreferenceUtil.setPreferenceValue("one", "1");

    //act
    final value = await sharedPreferenceUtil.getStringPreference("one");

    //assert
    expect("1", value);
  });

  test("should return null if the data is not saved", () async {
    // arrange
    //await sharedPreferenceUtil.setPreferenceValue("one", "1");

    //act
    final value = await sharedPreferenceUtil.getStringPreference("two");

    //assert
    expect(null, value);
  });
}