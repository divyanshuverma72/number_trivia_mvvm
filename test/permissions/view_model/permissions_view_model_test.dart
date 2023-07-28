import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_mvvm/permissions/view_model/permissions_view_model.dart';
import 'package:number_trivia_mvvm/util/permission_util.dart';

class MockPermissionUtil extends Mock implements PermissionUtil {}

void main() {
  late MockPermissionUtil mockPermissionUtil;
  late PermissionsViewModel permissionsViewModel;

  setUp(() {
    mockPermissionUtil = MockPermissionUtil();
    permissionsViewModel = PermissionsViewModel(permissionUtil: mockPermissionUtil);
  });

  test("should check if arePermissionsGranted method is called on permission util", () async {
    // arrange
    when(() => mockPermissionUtil.arePermissionsGranted()).thenAnswer((invocation) async => true);

    // act
    await permissionsViewModel.allPermissionsGranted();

    // assert
    verify(() => mockPermissionUtil.arePermissionsGranted());
  });

  test("should check if requestPermissions method is called on permission util", () async {
    // arrange
    when(() => mockPermissionUtil.requestPermissions()).thenAnswer((invocation) async => true);

    // act
    await permissionsViewModel.requestPermissions();

    // assert
    verify(() => mockPermissionUtil.requestPermissions());
  });

  testWidgets('should navigate to HomeScreenWidget', (WidgetTester tester) async {
    // arrange
    final GlobalKey key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                key: key,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );

    final context = key.currentContext!;

    // act
    permissionsViewModel.navigateToHomeScreen(context);
  });
}