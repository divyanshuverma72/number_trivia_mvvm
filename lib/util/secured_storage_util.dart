import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorageUtil {

  static SecuredStorageUtil? _instance;

  SecuredStorageUtil._();

  static SecuredStorageUtil get instance =>
      _instance ??= SecuredStorageUtil._();

  final _secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  writeSecureData(String key, dynamic value) async {
    await _secureStorage.write(key: key, value: value,
        aOptions: _getAndroidOptions());
  }

  Future<dynamic> readSecureData(String key) async {
    var readData = await _secureStorage.read(key: key,
        aOptions: _getAndroidOptions());
    return readData;
  }
}
