import 'package:dartz/dartz.dart';
import 'package:number_trivia_mvvm/exception.dart';
import 'package:number_trivia_mvvm/home/data/remote_data_source_repo.dart';

import '../../failure.dart';
import '../../util/network_info.dart';
import '../data/local_data_source_repo.dart';
import '../entities/number_trivia.dart';
import '../model/number_trivia_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int num);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}

typedef ConcreteOrRandom = Future<NumberTriviaModel> Function();
class HomeRepositoryImpl extends HomeRepository {

  NetworkInfo networkInfo;
  RemoteDataSourceRepo remoteDataSourceRepo;
  LocalDataSourceRepo localDataSourceRepo;

  HomeRepositoryImpl({required this.networkInfo, required this.remoteDataSourceRepo, required this.localDataSourceRepo});

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSourceRepo.getRandomNumberTrivia();
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int num) async {
    return await _getTrivia(() {
      return remoteDataSourceRepo.getConcreteNumberTrivia(num);
    });
  }

  Future<Either<Failure, NumberTriviaModel>> _getTrivia(
      //Use of functional programming
      //Future<NumberTriviaModel> Function() getConcreteOrRandom
      ConcreteOrRandom getConcreteOrRandom
      ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        await localDataSourceRepo.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException catch(e) {
        print("Exception caught Server $e");
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSourceRepo.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException catch(e) {
        print("Exception caught Cache $e");
        return Left(CacheFailure());
      }
    }
  }
}