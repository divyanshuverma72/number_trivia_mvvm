import 'package:number_trivia_mvvm/home/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {

  const NumberTriviaModel({required super.number, required super.text});

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(number: json['number'], text: json['text']);
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}