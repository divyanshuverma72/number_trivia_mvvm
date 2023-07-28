import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:number_trivia_mvvm/home/data/local_data_source_repo_secured_storage.dart';
import 'package:number_trivia_mvvm/util/network_info.dart';
import 'package:number_trivia_mvvm/util/permission_util.dart';
import 'package:number_trivia_mvvm/util/secured_storage_util.dart';
import 'package:number_trivia_mvvm/util/shared_preference_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/data/local_data_source_repo.dart';
import 'home/data/remote_data_source_repo.dart';
import 'home/repository/home_repo.dart';
import 'package:http/http.dart' as http;

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerFactory<HomeRepository>(() => HomeRepositoryImpl(
      networkInfo: locator(), remoteDataSourceRepo: locator(), localDataSourceRepo: locator()));

  locator.registerFactory<NetworkInfo>(() => NetWorkInfoImpl(locator()));
  locator.registerFactory(() => Connectivity());

  locator.registerFactory<RemoteDataSourceRepo>(() => RemoteDataSourceRepoImpl(locator()));
  locator.registerFactory<PermissionUtil>(() => PermissionUtilImpl());
  //locator.registerFactory<LocalDataSourceRepo>(() => LocalDataSourceRepoImpl(sharedPreferenceUtil: locator()));

  /*locator.registerFactory<LocalDataSourceRepo>(() => LocalDataSourceHiveImpl(numberTriviaHiveUtil: locator()));
  locator.registerFactory<NumberTriviaHiveUtil>(() => NumberTriviaHiveUtilImpl());*/

  locator.registerFactory<LocalDataSourceRepo>(() => LocalDataSourceRepoSecuredStorageImp(securedStorageUtil: locator()));
  final securedStorageUtil = SecuredStorageUtil.instance;
  locator.registerLazySingleton(()  => securedStorageUtil);

  final sharedPreferencesUtil = SharedPreferenceUtil.instance;
  locator.registerLazySingleton(()  => sharedPreferencesUtil);

  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(()  => sharedPreferences);
  locator.registerLazySingleton(() => http.Client());
}
