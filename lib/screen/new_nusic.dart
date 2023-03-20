import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicScreen extends StatelessWidget {
  MusicScreen({Key? key}) : super(key: key);

  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            player.play(
                "https://file-examples.com/storage/feb04797b46286b5ea5f061/2017/11/file_example_MP3_2MG.mp3");
          },
          child: Text("play"),
        ),
      ),
    );
  }
}
