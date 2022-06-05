import 'package:flutter/material.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_architecture_tdd_resocoder/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late TextEditingController textController = TextEditingController();
  late String inputStr;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          // TextField
          TextFormField(
            controller: textController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Input a number'),
            onChanged: (value) {
              inputStr = value;
            },
            validator: (textController) {
              if (textController == null || textController.isEmpty) {
                return 'Please enter some number';
              } else {
                return null;
              }
            },
          ),

          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      dispatchConcrete();
                    }
                  },
                  child: const Text('Search'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(mySwatch[100])),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: dispatchRandom,
                  child: const Text('Get rand trivia'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(mySwatch[700])),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void dispatchConcrete() {
    textController.clear();
    context
        .read<NumberTriviaBloc>()
        .add(GetTriviaForConcreteNumberEvent(numberString: inputStr));
  }

  void dispatchRandom() {
    textController.clear();
    context.read<NumberTriviaBloc>().add(GetTriviaForRandomNumberEvent());
  }
}
