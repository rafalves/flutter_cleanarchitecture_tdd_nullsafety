import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:mocktail/mocktail.dart';

import 'package:test/test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetConcreteNumberTrivia usecase;
  late int tNumber;
  late NumberTrivia tNumberTrivia;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
    tNumber = 7;
    tNumberTrivia = const NumberTrivia(text: 'text number trivia', number: 1);
  });

  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange
      when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      final result = await usecase(Params(number: tNumber));
      // assert
      expect(result, equals(Right(tNumberTrivia)));
      verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  ); // end test
}
