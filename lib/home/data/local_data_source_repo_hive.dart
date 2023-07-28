import 'dart:convert';

import 'package:number_trivia_mvvm/home/model/number_trivia_model.dart';

import '../../exception.dart';
import '../../util/hive_util.dart';
import 'local_data_source_repo.dart';

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class LocalDataSourceHiveImpl extends LocalDataSourceRepo {

  NumberTriviaHiveUtil numberTriviaHiveUtil;
  LocalDataSourceHiveImpl({required this.numberTriviaHiveUtil});

  @override
  cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    print("cacheNumberTrivia : Hive coming");
    numberTriviaHiveUtil.writeToHiveDb(json.encode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    print("getLastNumberTrivia : Hive coming");
    final jsonString = await numberTriviaHiveUtil.readFromHive();
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}