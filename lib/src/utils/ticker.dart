import 'dart:async';

class Ticker {
  const Ticker();

  Stream<int> tick(int ticks) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (value) => ticks - value - 1,
    ).take(ticks);
  }
}
