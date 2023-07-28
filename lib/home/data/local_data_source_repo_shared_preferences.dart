import 'dart:convert';
import '../../exception.dart';
import '../../util/shared_preference_util.dart';
import 'local_data_source_repo.dart';
import '../model/number_trivia_model.dart';

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';
class LocalDataSourceRepoImpl extends LocalDataSourceRepo {

  SharedPreferenceUtil sharedPreferenceUtil;
  LocalDataSourceRepoImpl({required this.sharedPreferenceUtil});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    print("getLastNumberTrivia : Shared Preferences coming");
    final jsonString = await sharedPreferenceUtil.getStringPreference(cachedNumberTrivia);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    print("cacheNumberTrivia : Shared Preferences coming");
    await sharedPreferenceUtil.setPreferenceValue(
      cachedNumberTrivia,
      json.encode(triviaToCache.toJson()),
    );
  }
}

