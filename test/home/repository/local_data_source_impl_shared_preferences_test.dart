import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_mvvm/exception.dart';
import 'package:number_trivia_mvvm/fixture_reader.dart';
import 'package:number_trivia_mvvm/home/data/local_data_source_repo_shared_preferences.dart';
import 'package:number_trivia_mvvm/home/model/number_trivia_model.dart';
import 'package:number_trivia_mvvm/util/shared_preference_util.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferenceUtil extends Mock implements SharedPreferenceUtil {}

void main() {

  late LocalDataSourceRepoImpl localDataSourceRepoImpl;
  late MockSharedPreferenceUtil mockSharedPreferenceUtil;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockSharedPreferenceUtil = MockSharedPreferenceUtil();
    localDataSourceRepoImpl = LocalDataSourceRepoImpl(sharedPreferenceUtil: mockSharedPreferenceUtil);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
          () async {
        // arrange
        when(() => mockSharedPreferenceUtil.getStringPreference(any()))
            .thenAnswer((invocation) async => fixture('trivia_cached.json'));
        // act
        final result = await localDataSourceRepoImpl.getLastNumberTrivia();
        // assert
        verify(() => mockSharedPreferenceUtil.getStringPreference(cachedNumberTrivia));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a CacheExeption when there is not a cached value',
          () async {
        // arrange
        when(() => mockSharedPreferenceUtil.getStringPreference(any())).thenAnswer((invocation) async => null);
        // act
        final call = localDataSourceRepoImpl.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });


  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
    NumberTriviaModel(number: 1, text: 'test trivia');

    test(
      'should call SharedPreferencesUtil to cache the data',
          () async {
        // act
            await localDataSourceRepoImpl.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(() => mockSharedPreferenceUtil.setPreferenceValue(
          cachedNumberTrivia,
          expectedJsonString,
        ));
      },
    );
  });
}