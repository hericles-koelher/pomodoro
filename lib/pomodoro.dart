import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/src/blocs.dart';
import 'package:pomodoro/src/screens.dart';
import 'package:wakelock/wakelock.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({Key? key}) : super(key: key);

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> with WidgetsBindingObserver {
  late final TimerBloc timerBloc;

  static const int minutesOfWork = 25;
  static const int minutesOfRest = 5;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    Wakelock.enable();

    timerBloc =
        TimerBloc(workMinutes: minutesOfWork, restMinutes: minutesOfRest);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      timerBloc.add(TimerWentInBackground());
      Wakelock.disable();
    } else if (state == AppLifecycleState.resumed) {
      timerBloc.add(TimerBackInForeground());
      Wakelock.enable();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    Wakelock.disable();

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
          appBarTheme: AppBarTheme(
            color: Colors.blueGrey[600],
          ),
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
