import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/src/blocs.dart';
import 'package:pomodoro/src/screens.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({Key? key}) : super(key: key);

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  late final TimerBloc timerBloc;

  @override
  void initState() {
    timerBloc = TimerBloc(workMinutes: 1, restMinutes: 1);

    super.initState();
  }

  @override
  void dispose() {
    timerBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: timerBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(10),
              backgroundColor: MaterialStateProperty.all(Colors.orange),
              textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 25),
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
