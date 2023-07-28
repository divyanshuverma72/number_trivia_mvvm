import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_mvvm/exception.dart';
import 'package:number_trivia_mvvm/failure.dart';
import 'package:number_trivia_mvvm/home/data/local_data_source_repo.dart';
import 'package:number_trivia_mvvm/home/data/remote_data_source_repo.dart';
import 'package:number_trivia_mvvm/home/model/number_trivia_model.dart';
import 'package:number_trivia_mvvm/home/repository/home_repo.dart';
import 'package:number_trivia_mvvm/util/network_info.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockRemoteDataSourceRepo extends Mock implements RemoteDataSourceRepo {}
class MockLocalDataSourceRepo extends Mock implements LocalDataSourceRepo {}

void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockRemoteDataSourceRepo mockRemoteDataSourceRepo;
  late MockLocalDataSourceRepo mockLocalDataSourceRepo;
  late HomeRepositoryImpl homeRepositoryImpl;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSourceRepo = MockRemoteDataSourceRepo();
    mockLocalDataSourceRepo = MockLocalDataSourceRepo();
    homeRepositoryImpl = HomeRepositoryImpl(networkInfo: mockNetworkInfo, remoteDataSourceRepo:
    mockRemoteDataSourceRepo, localDataSourceRepo: mockLocalDataSourceRepo);
  });

  group("GetConcreteNumberTrivia", () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "text");

    group("when device is online", () {

      setUp(() {
        //arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((invocation) async => true);
      });

      test("should return the data from the remote data source when the call to remote data source is successful", () async {
        //arrange
        when(() => mockRemoteDataSourceRepo.getConcreteNumberTrivia(any())).thenAnswer((_) async {
          return tNumberTriviaModel;
        });
        when(() => mockLocalDataSourceRepo.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((invocation) async => Future.value());
        //act
        final result = await homeRepositoryImpl.getConcreteNumberTrivia(tNumber);

        //assert
        verify(() => mockRemoteDataSourceRepo.getConcreteNumberTrivia(tNumber));
        expect(result, right(tNumberTriviaModel));
      });

      test("should cache the remote data locally when the call to remote data source is successful", () async {
        //arrange
        when(() => mockRemoteDataSourceRepo.getConcreteNumberTrivia(any())).thenAnswer((invocation) async => tNumberTriviaModel);
        when(() => mockLocalDataSourceRepo.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((invocation) async => Future.value());

        //act
        await homeRepositoryImpl.getConcreteNumberTrivia(tNumber);

        //assert
        verify(() => mockRemoteDataSourceRepo.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSourceRepo.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(() => mockRemoteDataSourceRepo.getConcreteNumberTrivia(any()))
              .thenThrow(ServerException());
          // act
          final result = await homeRepositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          verify(() => mockRemoteDataSourceRepo.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSourceRepo);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group("device id offline", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
            () async {
          // arrange
          when(() => mockLocalDataSourceRepo.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await homeRepositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSourceRepo);
          verify(() => mockLocalDataSourceRepo.getLastNumberTrivia());
          expect(result, const Right(tNumberTriviaModel));
        },
      );

      test(
        'should return cache failure when the cached data is not present',
            () async {
          // arrange
          when(() => mockLocalDataSourceRepo.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await homeRepositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSourceRepo);
          verify(() => mockLocalDataSourceRepo.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });


  group("GetRandomNumberTrivia", () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "text");

    group("when device is online", () {

      setUp(() {
        //arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((invocation) async => true);
      });

      test("should return the data from the remote data source when the call to remote data source is successful and cache the data"
          " locally", () async {
        //arrange
        when(() => mockRemoteDataSourceRepo.getRandomNumberTrivia()).thenAnswer((_) async {
          return tNumberTriviaModel;
        });
        when(() => mockLocalDataSourceRepo.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((invocation) async => Future.value());
        //act
        final result = await homeRepositoryImpl.getRandomNumberTrivia();

        //assert
        verify(() => mockRemoteDataSourceRepo.getRandomNumberTrivia());
        expect(result, right(tNumberTriviaModel));
      });

      test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(() => mockRemoteDataSourceRepo.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await homeRepositoryImpl.getRandomNumberTrivia();
          // assert
          verify(() => mockRemoteDataSourceRepo.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSourceRepo);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group("device id offline", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
            () async {
          // arrange
          when(() => mockLocalDataSourceRepo.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await homeRepositoryImpl.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSourceRepo);
          verify(() => mockLocalDataSourceRepo.getLastNumberTrivia());
          expect(result, const Right(tNumberTriviaModel));
        },
      );

      test(
        'should return cache failure when the cached data is not present',
            () async {
          // arrange
          when(() => mockLocalDataSourceRepo.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await homeRepositoryImpl.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSourceRepo);
          verify(() => mockLocalDataSourceRepo.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}