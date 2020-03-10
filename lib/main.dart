import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sample Beep',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

abstract class Sounds {
  static final beep = 'assets/scanner_beep.mp3';
  static final error = 'assets/network_error.mp3';
}

class _MyHomePageState extends State<MyHomePage> {
  final _flutterSound = new FlutterSound();
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: Opacity(
          opacity: _isPlaying ? 1 : 0,
          child: Icon(Icons.surround_sound),
        ),
        title: Text('Flutter Sample Beep'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.play_arrow),
            title: Text('Beep'),
            subtitle: Text('Short feedback to free up user from watching the screen'),
            onTap: () => _play(context, Sounds.beep),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.warning),
            title: Text('Error'),
            subtitle: Text('Gets the user to look at the error that happened'),
            onTap: () => _play(context, Sounds.error),
          ),
        ],
      ),
    );
  }

  Future<void> _play(BuildContext context, String path) async {
    final beep =
        await DefaultAssetBundle.of(context).load(path);
    final playback = new Completer.sync();
    setState(() {
      _isPlaying = true;
    });
    await _flutterSound.startPlayerFromBuffer(beep.buffer.asUint8List(),
        codec: t_CODEC.CODEC_MP3);
    var subscription = _flutterSound.onPlayerStateChanged.listen((event) {
      if (event == null) {
        return;
      }
      if (event.currentPosition == event.duration) {
        playback.complete();
      }
    });
    await playback.future;
    setState(() {
      _isPlaying = false;
    });
    subscription.cancel();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
