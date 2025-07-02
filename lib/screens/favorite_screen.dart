import 'dart:convert';
import 'package:cinestreamtunes/screens/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/music_data_model.dart';
import 'music_player screeen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Song> allSongs = [];
  List<Song> displayedSongs = [];
  List<String> moods = ['My mix'];
  String selectedMood = 'My mix';

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final String response = await rootBundle.loadString('lib/data/music_all.json');
    final List<dynamic> data = json.decode(response);
    final songs = data.map((e) => Song.fromJson(e)).toList();

    // Extract unique moods
    final extractedMoods = songs.map((s) => s.mood).toSet().toList()..sort();
    setState(() {
      allSongs = songs;
      displayedSongs = songs;
      moods = ['My mix', ...extractedMoods];
    });
  }

  void _filterByMood(String mood) {
    setState(() {
      selectedMood = mood;
      if (mood == 'My mix') {
        displayedSongs = allSongs;
      } else {
        displayedSongs = allSongs.where((song) => song.mood.toLowerCase() == mood.toLowerCase()).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A0CA3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.favorite_border, color: Colors.white),
        title: const Text("My Favourites", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMoodChips(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: displayedSongs.length,
              itemBuilder: (context, index) {
                final song = displayedSongs[index];
                return _buildSongTile(song);
              },
            ),
          ),
          _buildNowPlayingBar(displayedSongs.isNotEmpty ? displayedSongs.first : null),
        ],
      ),
    );
  }

  Widget _buildMoodChips() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: moods.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final mood = moods[index];
          final isSelected = mood == selectedMood;
          return ChoiceChip(
            label: Text(mood, style: TextStyle(color: isSelected ? Colors.white : Colors.white70)),
            selected: isSelected,
            selectedColor: Colors.deepPurple.shade500,
            backgroundColor: Colors.deepPurple.shade300,
            onSelected: (_) => _filterByMood(mood),
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          );
        },
      ),
    );
  }

  Widget _buildSongTile(Song song) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(song.thumbnail, width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(song.songTitle, style: const TextStyle(color: Colors.white)),
      subtitle: Text(song.singers.join(', '), style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.favorite, color: Colors.red),
      onTap: () => _navigateToPlayer(song),
    );
  }

  Widget _buildNowPlayingBar(Song? song) {
    if (song == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade700.withOpacity(0.8),
        border: const Border(top: BorderSide(color: Colors.white24)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(song.thumbnail, width: 48, height: 48, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(song.songTitle, style: const TextStyle(color: Colors.white, fontSize: 14), overflow: TextOverflow.ellipsis),
                Text(song.singers.join(', '), style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.play_circle, color: Colors.white, size: 30),
        ],
      ),
    );
  }

  void _navigateToPlayer(Song song) {
    final related = allSongs.where((s) => s.id != song.id).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SongPlayerScreen(song: song, relatedSongs: related),
      ),
    );
  }
}
