import 'dart:convert';

import 'package:flutter_architecture_tdd_resocoder/core/error/exceptions.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl datasource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    final mockUrl = Uri.parse('http://numbersapi.com/$tNumber');
    final mockHeaders = {'Content-Type': 'application/json'};

    test('''should perform a GET request on a URL with number 
        being the endpoint and application /json header''', () async {
      // arrange
      when(() => mockHttpClient.get(mockUrl, headers: mockHeaders))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      // act
      datasource.getContreteNumberTrivia(tNumber);
      // assert
      verify(() => mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      when(() => mockHttpClient.get(mockUrl, headers: mockHeaders))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      // act
      final result = await datasource.getContreteNumberTrivia(tNumber);
      // assert
      verify(() => mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(() => mockHttpClient.get(mockUrl, headers: mockHeaders))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = datasource.getContreteNumberTrivia;
      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    final mockUrl = Uri.parse('http://numbersapi.com/random');
    final mockHeaders = {'Content-Type': 'application/json'};

    test('''should perform a GET request on a URL with number 
        being the endpoint and application /json header''', () async {
      // arrange
      when(() => mockHttpClient.get(mockUrl, headers: mockHeaders))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      // act
      datasource.getRandomNumberTrivia();
      // assert
      verify(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      when(() => mockHttpClient.get(mockUrl, headers: mockHeaders))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      // act
      final result = await datasource.getRandomNumberTrivia();
      // assert
      verify(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(() => mockHttpClient.get(mockUrl, headers: mockHeaders))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = datasource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
