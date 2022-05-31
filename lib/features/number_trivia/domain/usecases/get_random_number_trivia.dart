import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_tdd_resocoder/core/error/failures.dart';
import 'package:flutter_architecture_tdd_resocoder/core/usecases/usecase.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia
    implements UseCase<Either<Failure, NumberTrivia>, NoParams> {
  final NumberTriviaRepository repository;

  const GetRandomNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
