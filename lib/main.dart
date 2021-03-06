import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData.dark(),
      home: MusicPlayer(),
    ));

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final audioName = "audio.mp3";
  final musicName = "Lil Jon – Snap Yo Fingers";
  final imageURL = "https://f4.bcbits.com/img/a3215224860_16.jpg";

  AudioPlayer audioPlayer;
  AudioCache audioCache;

  double volume = 1;
  double currentVolume;

  Duration duration = Duration();
  Duration position = Duration();

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.positionHandler = (p) => setState(() {
          position = p;
        });

    audioPlayer.durationHandler = (d) => setState(() {
          duration = d;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Player",
            style: TextStyle(fontSize: 20, color: Colors.purpleAccent)),
        centerTitle: true,
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(musicName, style: TextStyle(fontSize: 20)),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(imageURL)),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: audioControls(),
                    ),
                  ),
                  Slider(
                    activeColor: Colors.purpleAccent,
                    value: position.inSeconds.toDouble(),
                    max: duration.inSeconds.toDouble(),
                    onChanged: (double seconds) {
                      setState(() {
                        audioPlayer.seek(Duration(seconds: seconds.toInt()));
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget CreateIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 48,
      color: color,
      onPressed: onPressed,
    );
  }

  List<Widget> audioControls() {
    return <Widget>[
      CreateIconButton(Icons.play_arrow, Colors.green, () {
        audioCache.play(audioName);
      }),
      CreateIconButton(Icons.stop, Colors.grey, () {
        audioPlayer.stop();
      }),
      CreateIconButton(Icons.volume_up, Colors.green, () {
        if (volume < 1) {
          volume += 0.1;
          audioPlayer.setVolume(volume);
        }
      }),
      CreateIconButton(Icons.volume_down, Colors.red, () {
        if (volume > 0) {
          volume -= 0.1;
          audioPlayer.setVolume(volume);
        }
      }),
      CreateIconButton(Icons.volume_off, Colors.red, () {
        if (volume != 0) {
          currentVolume = volume;
          volume = 0;
        } else {
          volume = currentVolume;
        }
        audioPlayer.setVolume(volume);
      })
    ];
  }
}
