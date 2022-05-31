import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_tdd_resocoder/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final intFromString = int.parse(str);
      if (intFromString < 0) throw const FormatException();
      return Right(intFromString);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
