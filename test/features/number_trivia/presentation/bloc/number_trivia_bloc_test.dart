import 'package:flutter_architecture_tdd_resocoder/core/util/input_converter.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mocktail/mocktail.dart';
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

    test('initialState should be NumberTriviaEmptyState', () {});
  });
}
