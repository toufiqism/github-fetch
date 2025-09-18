import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/network_info.dart';
import '../data/datasources/github_local_data_source.dart';
import '../data/datasources/github_remote_data_source.dart';
import '../data/repositories/github_repository_impl.dart';
import '../domain/repositories/github_repository.dart';
import '../domain/usecases/search_repositories.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // External
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
    return dio;
  });
  sl.registerLazySingleton(() => Connectivity());
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Data sources
  sl.registerLazySingleton<GithubRemoteDataSource>(() => GithubRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<GithubLocalDataSource>(() => GithubLocalDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<GithubRepository>(() => GithubRepositoryImpl(
        remote: sl(),
        local: sl(),
        networkInfo: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => SearchRepositories(sl()));
}

