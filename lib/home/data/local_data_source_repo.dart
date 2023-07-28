import '../model/number_trivia_model.dart';

abstract class LocalDataSourceRepo {
  Future<NumberTriviaModel> getLastNumberTrivia();
  cacheNumberTrivia(NumberTriviaModel triviaToCache);
}