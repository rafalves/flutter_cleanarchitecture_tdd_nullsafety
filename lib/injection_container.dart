import 'package:flutter_architecture_tdd_resocoder/core/network/network_info.dart';
import 'package:flutter_architecture_tdd_resocoder/core/util/input_converter.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

Future<void> init() async {
  // Features - Number Trivia
  //  Bloc
  getIt.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: getIt(),
      getRandomNumberTrivia: getIt(),
      inputConverter: getIt(),
    ),
  );

  //  Use cases
  getIt.registerLazySingleton(
      () => GetConcreteNumberTrivia(repository: getIt()));
  getIt.registerLazySingleton(() => GetRandomNumberTrivia(repository: getIt()));

  //   Repository
  getIt.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  //   Data sources
  getIt.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: getIt(),
    ),
  );
  getIt.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: getIt(),
    ),
  );

  // Core
  getIt.registerLazySingleton(() => InputConverter());
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectionChecker: getIt(),
    ),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
