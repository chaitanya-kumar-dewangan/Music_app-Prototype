import 'package:flutter/material.dart';
import '../data/music_data_model.dart';
import 'music_player screeen.dart';

class SongListScreen extends StatelessWidget {
  final String title;
  final List<Song> songs;

  const SongListScreen({
    super.key,
    required this.title,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A0CA3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: songs.length,
        separatorBuilder: (_, __) => const Divider(color: Colors.white10),
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(song.thumbnail, width: 55, height: 55, fit: BoxFit.cover),
            ),
            title: Text(song.songTitle, style: const TextStyle(color: Colors.white)),
            subtitle: Text(song.singers.join(', '), style: const TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            onTap: () {
              final related = songs.where((s) => s.id != song.id).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SongPlayerScreen(song: song, relatedSongs: related),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
