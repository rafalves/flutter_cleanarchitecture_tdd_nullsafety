import 'package:flutter/material.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:flutter_architecture_tdd_resocoder/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter_architecture_tdd_resocoder/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NumberTriviaBloc>(),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          // Top half
          BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
            builder: (context, state) {
              if (state is NumberTriviaEmptyState) {
                return const MessageDisplay(
                  message: 'Start Searching!',
                );
              } else if (state is NumberTriviaLoadingState) {
                return const LoadingWidget();
              } else if (state is NumberTriviaLoadedState) {
                return TriviaDisplay(numberTrivia: state.trivia);
              } else if (state is NumberTriviaErrorState) {
                MessageDisplay(message: state.message);
              }
              return Container();
            },
          ),

          const SizedBox(height: 20),
          // Bottom half
          const TriviaControls(),
        ],
      ),
    );
  }
}
