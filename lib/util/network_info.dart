import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetWorkInfoImpl extends NetworkInfo {

  Connectivity connectivity;
  NetWorkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult ==  ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}