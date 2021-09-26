part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration;
  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

class PomodoroInitialState extends TimerState {
  const PomodoroInitialState(int duration) : super(duration);
}

class PomodoroRunningState extends TimerState {
  const PomodoroRunningState(int duration) : super(duration);
}

class PomodoroPausedState extends TimerState {
  const PomodoroPausedState(int duration) : super(duration);
}

class RestInitialState extends TimerState {
  const RestInitialState() : super(0);
}

class RestRunningState extends TimerState {
  const RestRunningState(int duration) : super(duration);
}

class RestTimeoutState extends TimerState {
  const RestTimeoutState() : super(0);
}
