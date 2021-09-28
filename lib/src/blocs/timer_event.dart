part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();
}

class TimerWentInBackground extends TimerEvent {
  final DateTime time;

  TimerWentInBackground() : time = DateTime.now();

  @override
  List<Object?> get props => [time];
}

class TimerBackInForeground extends TimerEvent {
  final DateTime time;

  TimerBackInForeground() : time = DateTime.now();

  @override
  List<Object?> get props => [time];
}

class _PomodoroTimerInitialized extends TimerEvent {
  @override
  List<Object?> get props => [];
}

class PomodoroTimerStarted extends TimerEvent {
  @override
  List<Object?> get props => [];
}

class _PomodoroTimerRunning extends TimerEvent {
  final int duration;
  const _PomodoroTimerRunning(this.duration) : super();

  @override
  List<Object?> get props => [duration];
}

class PomodoroTimerPaused extends TimerEvent {
  final int duration;
  const PomodoroTimerPaused(this.duration);

  @override
  List<Object?> get props => [duration];
}

class PomodoroTimerResumed extends TimerEvent {
  @override
  List<Object?> get props => [];
}

class PomodoroTimerReset extends TimerEvent {
  @override
  List<Object?> get props => [];
}

class _RestTimerInitialized extends TimerEvent {
  @override
  List<Object?> get props => [];
}

class RestTimerStarted extends TimerEvent {
  @override
  List<Object?> get props => [];
}

class _RestTimerRunning extends TimerEvent {
  final int duration;

  const _RestTimerRunning(this.duration);

  @override
  List<Object?> get props => [duration];
}

class RestTimerEnded extends TimerEvent {
  @override
  List<Object?> get props => [];
}
