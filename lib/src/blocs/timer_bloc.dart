import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pomodoro/src/utils/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final int _duration;
  final int _restDuration;
  final Ticker _ticker = const Ticker();
  StreamSubscription<int>? _streamSubscription;

  TimerBloc(int workMinutes, int restMinutes)
      : assert(workMinutes > 0),
        assert(restMinutes > 0),
        _duration = workMinutes * 60,
        _restDuration = restMinutes * 60,
        super(PomodoroInitialState(workMinutes * 60)) {
    on<_PomodoroTimerInitialized>(_init);
    on<PomodoroTimerStarted>(_start);
    on<_PomodoroTimerRunning>(_tick);
    on<PomodoroTimerPaused>(_pause);
    on<PomodoroTimerResumed>(_resume);
    on<PomodoroTimerReset>(_reset);
    on<_RestTimerInitialized>(_rest);
    on<RestTimerStarted>(_restStart);
    on<_RestTimerRunning>(_restTick);
    on<RestTimerEnded>(_restEnd);
  }

  void _init(_PomodoroTimerInitialized event, Emitter<TimerState> emit) {
    emit(PomodoroInitialState(_duration));
  }

  void _start(PomodoroTimerStarted event, Emitter<TimerState> emit) {
    emit(PomodoroRunningState(_duration));

    _streamSubscription?.cancel();
    _streamSubscription = _ticker.tick(_duration).listen(
      (duration) {
        add(_PomodoroTimerRunning(duration));
      },
    );
  }

  void _tick(_PomodoroTimerRunning event, Emitter<TimerState> emit) {
    emit(PomodoroRunningState(event.duration));

    if (event.duration == 0) {
      add(_RestTimerInitialized());
    }
  }

  void _pause(PomodoroTimerPaused event, Emitter<TimerState> emit) {
    if (state is PomodoroRunningState) {
      _streamSubscription?.pause();

      emit(PomodoroPausedState(state.duration));
    }
  }

  void _resume(PomodoroTimerResumed event, Emitter<TimerState> emit) {
    if (state is PomodoroPausedState) {
      _streamSubscription?.resume();

      emit(PomodoroRunningState(state.duration));
    }
  }

  void _reset(PomodoroTimerReset event, Emitter<TimerState> emit) {
    if (state is PomodoroRunningState || state is PomodoroPausedState) {
      _streamSubscription?.cancel();
      emit(PomodoroInitialState(_duration));
    }
  }

  void _rest(_RestTimerInitialized event, Emitter<TimerState> emit) {
    emit(const RestInitialState());
  }

  void _restStart(RestTimerStarted event, Emitter<TimerState> emit) {
    if (state is RestInitialState) {
      emit(RestRunningState(_restDuration));

      _streamSubscription?.cancel();
      _streamSubscription = _ticker.tick(_restDuration).listen(
        (duration) {
          add(_RestTimerRunning(duration));
        },
      );
    }
  }

  void _restTick(_RestTimerRunning event, Emitter<TimerState> emit) {
    emit(RestRunningState(event.duration));

    if (event.duration == 0) {
      emit(const RestTimeoutState());
    }
  }

  void _restEnd(RestTimerEnded event, Emitter<TimerState> emit) {
    if (state is RestTimeoutState) {
      add(_PomodoroTimerInitialized());
    }
  }
}
