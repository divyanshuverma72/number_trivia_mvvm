import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_mvvm/exception.dart';
import 'package:number_trivia_mvvm/fixture_reader.dart';
import 'package:number_trivia_mvvm/home/model/number_trivia_model.dart';
import 'package:number_trivia_mvvm/home/data/local_data_source_repo_secured_storage.dart';
import 'package:number_trivia_mvvm/util/secured_storage_util.dart';

class MockSecuredStorageUtil extends Mock implements SecuredStorageUtil{}

void main() {

  late LocalDataSourceRepoSecuredStorageImp localDataSourceRepoSecuredStorageImp;
  late MockSecuredStorageUtil mockSecuredStorageUtil;

  setUp(() {
    mockSecuredStorageUtil = MockSecuredStorageUtil();
    localDataSourceRepoSecuredStorageImp = LocalDataSourceRepoSecuredStorageImp(securedStorageUtil: mockSecuredStorageUtil);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
          () async {
        // arrange
        when(() => mockSecuredStorageUtil.readSecureData(any()))
            .thenAnswer((invocation) async => fixture('trivia_cached.json'));
        // act
        final result = await localDataSourceRepoSecuredStorageImp.getLastNumberTrivia();
        // assert
        verify(() => mockSecuredStorageUtil.readSecureData(cachedNumberTrivia));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
          () async {
        // arrange
        when(() => mockSecuredStorageUtil.readSecureData(any())).thenAnswer((invocation) async => null);
        // act
        final call = localDataSourceRepoSecuredStorageImp.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });


  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
    NumberTriviaModel(number: 1, text: 'test trivia');

    test(
      'should call SecuredStoragesUtil to cache the data',
          () async {
        // act
            localDataSourceRepoSecuredStorageImp.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(() => mockSecuredStorageUtil.writeSecureData(
          cachedNumberTrivia,
          expectedJsonString,
        ));
      },
    );
  });
}