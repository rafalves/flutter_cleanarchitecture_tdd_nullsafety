part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaEmptyState extends NumberTriviaState {}

class NumberTriviaLoadingState extends NumberTriviaState {}

class NumberTriviaLoadedState extends NumberTriviaState {
  final NumberTrivia trivia;

  @override
  List<Object> get props => [trivia];

  const NumberTriviaLoadedState({required this.trivia});
}

class NumberTriviaErrorState extends NumberTriviaState {
  final String message;

  const NumberTriviaErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
