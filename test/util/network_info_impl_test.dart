import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_mvvm/util/network_info.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main () {
  late NetWorkInfoImpl networkInfoImpl;
  late Connectivity connectivity;

  setUp(() {
    connectivity = MockConnectivity();
    networkInfoImpl = NetWorkInfoImpl(connectivity);
  });

  group("is connected", () {
    test("should forward the call to connectivity.checkConnectivity()", () async {
      //arrange
      when(() => connectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.mobile);

      //act
      final result = await networkInfoImpl.isConnected;

      //assert
      verify(() => connectivity.checkConnectivity());
      expect(result, true);
    });
  });
}