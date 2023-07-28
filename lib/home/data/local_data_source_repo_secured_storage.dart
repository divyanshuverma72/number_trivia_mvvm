import 'dart:convert';

import 'package:number_trivia_mvvm/home/model/number_trivia_model.dart';
import 'package:number_trivia_mvvm/util/secured_storage_util.dart';

import '../../exception.dart';
import 'local_data_source_repo.dart';

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';
class LocalDataSourceRepoSecuredStorageImp extends LocalDataSourceRepo {

  late SecuredStorageUtil securedStorageUtil;
  LocalDataSourceRepoSecuredStorageImp({required this.securedStorageUtil});

  @override
  cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    print("cacheNumberTrivia : Secured Storage");
    securedStorageUtil.writeSecureData(
      cachedNumberTrivia,
      json.encode(triviaToCache.toJson()),
    );
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    print("getLastNumberTrivia : Secured Storage");
    final jsonString = await securedStorageUtil.readSecureData(cachedNumberTrivia);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}