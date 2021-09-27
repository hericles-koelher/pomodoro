import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs.dart';

class AlarmScreen extends StatelessWidget {
  final String label;
  final TimerEvent timerEvent;

  static final AudioCache _player = AudioCache(prefix: "assets/audio/")
    ..load("mixkit-urgent-simple-tone-loop-2976.wav");

  const AlarmScreen({Key? key, required this.label, required this.timerEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerBloc = BlocProvider.of<TimerBloc>(context);
    final textTheme = Theme.of(context).textTheme;

    final Future<AudioPlayer> futurePlayer =
        _player.loop("mixkit-urgent-simple-tone-loop-2976.wav");

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: textTheme.headline4,
                  ),
                ),
                const Spacer(),
                const Flexible(
                  child: FaIcon(
                    FontAwesomeIcons.hourglassEnd,
                    size: 50,
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: ElevatedButton(
                    child: const Text(
                      "Tap to cancel",
                    ),
                    onPressed: () {
                      timerBloc.add(timerEvent);
                      futurePlayer.then((audioPlayer) => audioPlayer.stop());
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
