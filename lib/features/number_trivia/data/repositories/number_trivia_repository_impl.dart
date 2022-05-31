import 'package:flutter_architecture_tdd_resocoder/core/error/exceptions.dart';
import 'package:flutter_architecture_tdd_resocoder/core/network/network_info.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getTrivia(
        () async => await remoteDataSource.getContreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(
        () async => await remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      Future<NumberTriviaModel> Function() getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        await localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
