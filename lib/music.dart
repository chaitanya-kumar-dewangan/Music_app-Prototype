import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late YoutubePlayerController _controller;
  Map<String, dynamic>? song;

  @override
  void initState() {
    super.initState();
    _loadSongFromJson();
  }

  void _loadSongFromJson() {
    // Simulating JSON fetch (you can replace this with a real API call)
    const String jsonString = '''
    [
      {
        "song_title": "Tum Hi Ho",
        "singers": ["Arijit Singh"],
        "audio_url": "https://music.youtube.com/watch?v=fsiPzT50ZiM",
        "thumbnail": "https://i.pinimg.com/236x/d9/05/e6/d905e6be0f849b716a6011df2d37e383.jpg",
        "movie_name": "Aashiqui 2",
        "id": "101"
      }
    ]
    ''';

    final List data = json.decode(jsonString);
    setState(() {
      song = data[0];
      final videoId = YoutubePlayer.convertUrlToId(song!['audio_url']);
      _controller = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(autoPlay: true),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (song == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(title: const Text("Now Playing")),
          body: Column(
            children: [
              player,
              const SizedBox(height: 20),
              Text(
                song!['song_title'] ?? '',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(song!['movie_name'] ?? ''),
            ],
          ),
        );
      },
    );
  }
}
