import 'dart:convert';
import 'package:number_trivia_mvvm/exception.dart';

import '../model/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia_mvvm/constants.dart' as constants;

abstract class RemoteDataSourceRepo {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int num);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class RemoteDataSourceRepoImpl extends RemoteDataSourceRepo {

  final http.Client httpClient;
  RemoteDataSourceRepoImpl(this.httpClient);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int num) async {
    final response = await httpClient.get(
      Uri.parse("${constants.concreteNumberTriviaUrl}$num"),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await httpClient.get(
      Uri.parse(constants.randomNumberTriviaUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}