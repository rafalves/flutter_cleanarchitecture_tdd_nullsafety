import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_tdd_resocoder/core/error/failures.dart';
import 'package:flutter_architecture_tdd_resocoder/core/util/input_converter.dart';
import 'package:flutter_architecture_tdd_resocoder/core/util/strings.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () async {
    //assert
    expect(bloc.state, equals(NumberTriviaEmptyState()));
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
        'should call the InputConverter to validade and convert the string to an unsigned integer',
        () async {
      // arrange
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(const Right(tNumberParsed));
      when(() =>
              mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)))
          .thenAnswer((invocation) async => const Right(tNumberTrivia));
      // act
      bloc.add(
          const GetTriviaForConcreteNumberEvent(numberString: tNumberString));
      await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(any()));
      // assert
      verify((() => mockInputConverter.stringToUnsignedInteger(tNumberString)));
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when the input is invalid',
      setUp: () => when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(Left(InvalidInputFailure())),
      build: () => bloc,
      act: (bloc) => bloc.add(
          const GetTriviaForConcreteNumberEvent(numberString: tNumberString)),
      expect: () =>
          [const NumberTriviaErrorState(message: invalidInputFailureMessage)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the concrete use case',
      setUp: () {
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));
        when(() => mockGetConcreteNumberTrivia(
                const Params(number: tNumberParsed)))
            .thenAnswer((invocation) async => const Right(tNumberTrivia));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(
          const GetTriviaForConcreteNumberEvent(numberString: tNumberString)),
      verify: (bloc) =>
          mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));
        when(() => mockGetConcreteNumberTrivia(
                const Params(number: tNumberParsed)))
            .thenAnswer((invocation) async => const Right(tNumberTrivia));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(
          const GetTriviaForConcreteNumberEvent(numberString: tNumberString)),
      expect: () => [
        NumberTriviaLoadingState(),
        const NumberTriviaLoadedState(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, NumberTriviaErrorState] when data is gotten successfully',
      setUp: () {
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));
        when(() => mockGetConcreteNumberTrivia(
                const Params(number: tNumberParsed)))
            .thenAnswer((invocation) async => Left(ServerFailure()));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(
          const GetTriviaForConcreteNumberEvent(numberString: tNumberString)),
      expect: () => [
        NumberTriviaLoadingState(),
        const NumberTriviaErrorState(message: serverFailureMessage),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, NumberTriviaErrorState] with a proper message for the error when getting data fails',
      setUp: () {
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));
        when(() => mockGetConcreteNumberTrivia(
                const Params(number: tNumberParsed)))
            .thenAnswer((invocation) async => Left(CacheFailure()));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(
          const GetTriviaForConcreteNumberEvent(numberString: tNumberString)),
      expect: () => [
        NumberTriviaLoadingState(),
        const NumberTriviaErrorState(message: cacheFailureMessage),
      ],
    );
  });
}
