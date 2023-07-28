import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_mvvm/home/entities/number_trivia.dart';
import 'package:number_trivia_mvvm/home/model/number_trivia_model.dart';

void main() {
  const numberTriviaModel = NumberTriviaModel(number: 1, text: "text");

  test("model should be a subclass of NumberTrivia entity", () {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  test("should return a valid model fromJson", () {
    //arrange
    final json = {
      "text": "text",
      "number": 1,
      "found": true,
      "type": "trivia"
    };

    //act
    final model = NumberTriviaModel.fromJson(json);

    //assert
    expect(model, numberTriviaModel);
  });

  test("should return a jsonMap with proper data from the NumberTriviaModel", () {
    //arrange
    final jsonMap = {
      'text' : "text",
      'number' : 1
    };

    //act
    final result = numberTriviaModel.toJson();

    //assert
    expect(result, jsonMap);
  });

}