import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_mvvm/util/secured_storage_util.dart';

void main() {
  late SecuredStorageUtil securedStorageUtil;
  setUp(() {
    /// We can mock the data like this also in secured storage
    FlutterSecureStorage.setMockInitialValues({"three" : "3"});
    securedStorageUtil = SecuredStorageUtil.instance;
  });

  test("Check if the values are getting stored in the SecuredStorageUtil correctly", () async {
    // arrange
    await securedStorageUtil.writeSecureData("one", "1");

    //act
    final value = await securedStorageUtil.readSecureData("one");

    //assert
    expect("1", value);
  });

  test("should return null if the data is not saved", () async {
    // arrange
    //await sharedPreferenceUtil.setPreferenceValue("one", "1");

    //act
    final value = await securedStorageUtil.readSecureData("two");

    //assert
    expect(null, value);
  });
}