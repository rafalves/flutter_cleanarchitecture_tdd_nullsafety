import 'package:flutter_architecture_tdd_resocoder/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockDataConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward call to InternetConnectionChecker.hasConnection',
        () async {
      // arrange
      final tHasConnectionFuture = Future.value(true);
      when(() => mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);
      // act
      final result = networkInfo.isConnected;
      // assert
      verify(() => mockDataConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
