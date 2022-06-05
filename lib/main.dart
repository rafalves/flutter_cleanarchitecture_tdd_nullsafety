import 'package:flutter/material.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primarySwatch: const MaterialColor(myPrimary, mySwatch),
      ),
      home: const NumberTriviaPage(),
    );
  }
}

// custom colors
const myPrimary = 0xFF1B5E20;
const mySwatch = {
  50: Color.fromRGBO(76, 175, 80, 1),
  100: Color.fromRGBO(67, 160, 71, 1),
  200: Color.fromRGBO(56, 142, 60, 1),
  300: Color.fromRGBO(46, 125, 50, 1),
  500: Color.fromRGBO(27, 94, 32, 1),
  600: Color.fromRGBO(33, 150, 243, 1),
  700: Color.fromRGBO(30, 136, 229, 1),
  800: Color.fromRGBO(25, 118, 210, 1),
  900: Color.fromRGBO(21, 101, 192, 1),
};
