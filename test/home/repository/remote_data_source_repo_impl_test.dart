import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_mvvm/exception.dart';
import 'package:number_trivia_mvvm/fixture_reader.dart';
import 'package:number_trivia_mvvm/home/data/remote_data_source_repo.dart';
import 'package:number_trivia_mvvm/home/model/number_trivia_model.dart';
import 'package:number_trivia_mvvm/constants.dart' as constants;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late RemoteDataSourceRepoImpl remoteDataSourceRepoImpl;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSourceRepoImpl = RemoteDataSourceRepoImpl(mockHttpClient);
    registerFallbackValue(Uri.parse(constants.concreteNumberTriviaUrl));
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group("getConcreteNumberTrivia", () {
    int tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "text");
    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        await remoteDataSourceRepoImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await remoteDataSourceRepoImpl.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = remoteDataSourceRepoImpl.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        remoteDataSourceRepoImpl.getRandomNumberTrivia();
        // assert
        verify(() => mockHttpClient.get(
          Uri.parse(constants.randomNumberTriviaUrl),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await remoteDataSourceRepoImpl.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = remoteDataSourceRepoImpl.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}