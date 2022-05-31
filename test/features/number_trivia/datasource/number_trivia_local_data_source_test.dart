import 'dart:convert';

import 'package:flutter_architecture_tdd_resocoder/core/error/exceptions.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        'should return NumberTriviaModel from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(() => mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      // act
      final call = dataSource.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPreferences to chache the data', () {
      // arrange
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) => Future.value(true));
      // act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(() => mockSharedPreferences.setString(
          cachedNumberTrivia, expectedJsonString));
    });
  });
}
