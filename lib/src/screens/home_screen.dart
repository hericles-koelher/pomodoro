import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomodoro/src/blocs.dart';

import '../screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<TimerBloc, TimerState>(
          listenWhen: (previousState, currentState) {
            bool shouldListen = false;

            if (currentState is RestInitialState ||
                currentState is RestTimeoutState) {
              shouldListen = true;
            }

            return shouldListen;
          },
          buildWhen: (previousState, currentState) {
            bool shouldRebuild = true;

            if (currentState is RestInitialState ||
                currentState is RestTimeoutState) {
              shouldRebuild = false;
            }

            return shouldRebuild;
          },
          listener: _timerBlocListener,
          builder: _screenBuilder,
        ),
      ),
    );
  }

  void _timerBlocListener(context, state) {
    String alarmScreenLabel;
    TimerEvent timerEvent;

    if (state is RestInitialState) {
      alarmScreenLabel = "Study time is over!";
      timerEvent = RestTimerStarted();
    } else {
      alarmScreenLabel = "Rest time is over!";
      timerEvent = RestTimerEnded();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlarmScreen(
          label: alarmScreenLabel,
          timerEvent: timerEvent,
        ),
      ),
    );
  }

  Widget _screenBuilder(BuildContext context, TimerState state) {
    final timerBloc = BlocProvider.of<TimerBloc>(context);
    bool shouldSeeSettings = state is PomodoroInitialState;
    double iconSize = MediaQuery.of(context).size.width / 12;
    double gifHeight = MediaQuery.of(context).size.height / 3;
    double gifWidth = MediaQuery.of(context).size.width / 1.5;

    String gifPath = "assets/image/cat_studying.gif";

    List<Widget> rowChildren = [];

    if (state is PomodoroInitialState) {
      rowChildren = [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.play),
          iconSize: iconSize,
          onPressed: () {
            timerBloc.add(PomodoroTimerStarted());
          },
        ),
      ];
    } else if (state is PomodoroRunningState) {
      rowChildren = [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.pause),
          iconSize: iconSize,
          onPressed: () {
            timerBloc.add(PomodoroTimerPaused(state.duration));
          },
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.stop),
          iconSize: iconSize,
          onPressed: () {
            timerBloc.add(PomodoroTimerReset());
          },
        ),
      ];
    } else if (state is PomodoroPausedState) {
      rowChildren = [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.play),
          iconSize: iconSize,
          onPressed: () {
            timerBloc.add(PomodoroTimerResumed());
          },
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.stop),
          iconSize: iconSize,
          onPressed: () {
            timerBloc.add(PomodoroTimerReset());
          },
        ),
      ];
    } else if (state is RestRunningState) {
      gifPath = "assets/image/cat_sleeping.gif";
    }

    return Stack(
      children: [
        if (shouldSeeSettings)
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.cog,
                color: Colors.grey[900],
              ),
              iconSize: iconSize,
              onPressed: () {},
            ),
          ),
        Align(
          alignment: Alignment.bottomRight,
          // TODO: substituir por animação com fundo transparente
          child: SizedBox(
            height: gifHeight,
            width: gifWidth,
            child: Image.asset(gifPath),
          ),
        ),
        Align(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 4,
                child: Text(
                  formatDuration(state.duration),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: rowChildren,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatDuration(int duration) {
    String minutes = (duration ~/ 60).toString().padLeft(2, "0");
    String seconds = (duration % 60).toString().padLeft(2, "0");

    return "$minutes:$seconds";
  }
}
