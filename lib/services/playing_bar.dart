import 'package:cinestreamtunes/services/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/music_player screeen.dart';


class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<YoutubePlayerProvider>(context);
    final song = player.currentSong;

    if (song == null) return const SizedBox();

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => SongPlayerScreen(
            song: song,
            relatedSongs: [], // You can pass actual related songs here
          ),
        ));
      },
      child: Container(
        color: Colors.deepPurple.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(song.thumbnail),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(song.songTitle,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      overflow: TextOverflow.ellipsis),
                  Text(song.singers.join(', '),
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                player.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                player.togglePlayPause();
              },
            ),
          ],
        ),
      ),
    );
  }
}
