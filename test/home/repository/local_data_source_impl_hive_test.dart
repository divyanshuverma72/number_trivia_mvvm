import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_mvvm/exception.dart';
import 'package:number_trivia_mvvm/fixture_reader.dart';
import 'package:number_trivia_mvvm/util/hive_util.dart';
import 'package:number_trivia_mvvm/home/model/number_trivia_model.dart';
import 'package:number_trivia_mvvm/home/data/local_data_source_repo_hive.dart';

class MockNumberTriviaHiveUtil extends Mock implements NumberTriviaHiveUtil{}
void main() {

  late LocalDataSourceHiveImpl localDataSourceImplHive;
  late MockNumberTriviaHiveUtil mockNumberTriviaHiveUtil;
  
  setUp(() {
    mockNumberTriviaHiveUtil = MockNumberTriviaHiveUtil();
    localDataSourceImplHive = LocalDataSourceHiveImpl(numberTriviaHiveUtil: mockNumberTriviaHiveUtil);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
          () async {
        // arrange
        when(() => mockNumberTriviaHiveUtil.readFromHive())
            .thenAnswer((invocation) async => fixture('trivia_cached.json'));
        // act
        final result = await localDataSourceImplHive.getLastNumberTrivia();
        // assert
        verify(() => mockNumberTriviaHiveUtil.readFromHive());
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a CacheExeption when there is not a cached value',
          () async {
        // arrange
        when(() => mockNumberTriviaHiveUtil.readFromHive()).thenAnswer((invocation) async => null);
        // act
        final call = localDataSourceImplHive.getLastNumberTrivia;
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
        await localDataSourceImplHive.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(() => mockNumberTriviaHiveUtil.writeToHiveDb(
            expectedJsonString
        ));
      },
    );
  });
}