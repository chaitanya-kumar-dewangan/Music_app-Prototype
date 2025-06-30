import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/music_data_model.dart';
import 'music_player screeen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Song> bollywoodSongs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final String response = await rootBundle.loadString('lib/data/music_all.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      bollywoodSongs = data
          .map((e) => Song.fromJson(e))
          .where((song) => song.category.toLowerCase() == 'bollywood')
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A0CA3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A0CA3),
        elevation: 0,
        title: const Text(
          "History",
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: bollywoodSongs.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow, color: Colors.white,),
                    label: const Text("Play", style: TextStyle(color: Colors.white, fontSize: 22),),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.shuffle, color: Colors.white,),
                    label: const Text("Shuffle", style: TextStyle(color: Colors.white, fontSize: 22),),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: bollywoodSongs.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white10),
              itemBuilder: (context, index) {
                final song = bollywoodSongs[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song.thumbnail,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song.songTitle,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    song.singers.join(', '),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.more_vert, color: Colors.white70),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SongPlayerScreen(
                          song: song,
                          relatedSongs: bollywoodSongs,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // _buildNowPlayingBar(),
        ],
      ),
    );
  }

  Widget _buildNowPlayingBar() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade600,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.graphic_eq, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tum hi ho", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("Arijit Singh", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Text("3:20", style: TextStyle(color: Colors.white60, fontSize: 12)),
          SizedBox(width: 8),
          Icon(Icons.pause_circle_filled, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}
