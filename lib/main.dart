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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Sample Beep'),
      ),
      body: Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _playBeep(context),
        tooltip: 'Beep',
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  Future<void> _playBeep(BuildContext context) async {
    final beep =
        await DefaultAssetBundle.of(context).load('asset/scanner_beep.ac3');
    final flutterSound = new FlutterSound();
    final playback = new Completer.sync();
    await flutterSound.startPlayerFromBuffer(beep.buffer.asUint8List(),
        codec: t_CODEC.CODEC_AAC);
    final subscription = flutterSound.onPlayerStateChanged.listen((event) {
      if (event == null) {
        return;
      }
      if (event.currentPosition == event.duration) {
        playback.complete();
      }
    });
    await playback.future;
    subscription.cancel();
  }
}
