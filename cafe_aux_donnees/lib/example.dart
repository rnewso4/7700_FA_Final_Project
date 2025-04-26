import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cafe_aux_donnees/backend_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(create: (context) => BackendBloc(), child: MyWidget()),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final backendBloc = BlocProvider.of<BackendBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Flutter App with Python Backend')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            backendBloc.fetchData();
          },
          child: BlocBuilder<BackendBloc, String>(
            builder: (context, state) {
              return Text(state);
            },
          ),
        ),
      ),
    );
  }
}
