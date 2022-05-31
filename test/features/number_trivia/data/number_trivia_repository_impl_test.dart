import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_tdd_resocoder/core/error/exceptions.dart';
import 'package:flutter_architecture_tdd_resocoder/core/error/failures.dart';
import 'package:flutter_architecture_tdd_resocoder/core/network/network_info.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'Test text');
    NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((invocation) => Future.value());
      when(() => mockRemoteDataSource.getContreteNumberTrivia(any()))
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getContreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((invocation) => Future.value());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getContreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getContreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((invocation) => Future.value());
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getContreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getContreteNumberTrivia(any()))
            .thenThrow(ServerException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getContreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    runTestOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyNoMoreInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data is present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyNoMoreInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'Test text');
    NumberTrivia tNumberTrivia = tNumberTriviaModel;

    group('device is online ', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should check if the device is online', () {
        // arrange
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((invocation) => Future.value());
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        repository.getRandomNumberTrivia();
        // assert
        verify(() => mockNetworkInfo.isConnected);
      });

      test(
          'should return remote data when the call to remote data source is successful1',
          () async {
        // arrange
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((invocation) => Future.value());
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((invocation) => Future.value());
        // act
        await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verifyNoMoreInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data is present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verifyNoMoreInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
