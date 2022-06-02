import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_tdd_resocoder/core/error/failures.dart';
import 'package:flutter_architecture_tdd_resocoder/core/usecases/usecase.dart';
import 'package:flutter_architecture_tdd_resocoder/core/util/input_converter.dart';
import 'package:flutter_architecture_tdd_resocoder/core/util/strings.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(NumberTriviaEmptyState()) {
    on<GetTriviaForConcreteNumberEvent>((event, emit) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      inputEither.fold(
        (failure) => emit(
            const NumberTriviaErrorState(message: invalidInputFailureMessage)),
        (integer) async {
          emit(NumberTriviaLoadingState());
          final failureOrSuccess =
              await getConcreteNumberTrivia(Params(number: integer));
          failureOrSuccess.fold(
            (failure) => emit(
                NumberTriviaErrorState(message: _mapFailureToMessage(failure))),
            (numberTrivia) =>
                emit(NumberTriviaLoadedState(trivia: numberTrivia)),
          );
        },
      );
    });
    on<GetTriviaForRandomNumberEvent>(
      (event, emit) async {
        emit(NumberTriviaLoadingState());
        final failureOrSuccess = await getRandomNumberTrivia(NoParams());
        failureOrSuccess.fold(
          (failure) => emit(
              NumberTriviaErrorState(message: _mapFailureToMessage(failure))),
          (numberTrivia) => emit(NumberTriviaLoadedState(trivia: numberTrivia)),
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
