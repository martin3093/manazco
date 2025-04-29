import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/bloc/counter_bloc/counter_bloc.dart';
import 'package:manazco/bloc/counter_bloc/counter_event.dart';
import 'package:manazco/bloc/counter_bloc/counter_state.dart';

class ContadorBloc extends StatelessWidget {
  const ContadorBloc({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Center(
          child: BlocBuilder<CounterBloc, CounterState>(
            builder: (context, state) {
              String message;
              Color messageColor;

              // Determina el mensaje y el color según el valor del contador
              if (state.count > 0) {
                message = 'Contador en positivo';
                messageColor = Colors.green;
              } else if (state.count == 0) {
                message = 'Contador en cero';
                messageColor = Colors.black;
              } else {
                message = 'Contador en negativo';
                messageColor = Colors.red;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${state.count}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(fontSize: 18, color: messageColor),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Alinea los botones al final
          children: [
            FloatingActionButton(
              onPressed:
                  () => context.read<CounterBloc>().add(DecrementEvent()),
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 16), // Espaciado entre los botones
            FloatingActionButton(
              onPressed:
                  () => context.read<CounterBloc>().add(IncrementEvent()),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 16), // Espaciado entre los botones
            FloatingActionButton(
              onPressed: () => context.read<CounterBloc>().add(ResetEvent()),
              tooltip: 'Reset',
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
