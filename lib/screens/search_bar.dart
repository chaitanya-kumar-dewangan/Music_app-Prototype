
import 'dart:convert';
import 'package:cinestreamtunes/screens/song_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/music_data_model.dart';
import 'music_player screeen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> allSongs = [];
  List<dynamic> filteredSongs = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final String response = await rootBundle.loadString('lib/data/music_all.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      allSongs = data;
      filteredSongs = data;
    });
  }

  void _filterSongs(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredSongs = allSongs.where((song) {
        final songMap = Map<String, dynamic>.from(song);
        return songMap.values.any((value) {
          if (value is List) {
            return value.any((v) => v.toString().toLowerCase().contains(searchQuery));
          }
          return value.toString().toLowerCase().contains(searchQuery);
        });
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final emotionalSongs = allSongs.where((s) => s['mood'] == 'Emotional').toList();
    final popularSongs = allSongs.where((s) => s['category'] == 'Tollywood').toList();

    final Map<String, List> languageSpecific = {};
    for (var song in allSongs) {
      final category = song['category'] ?? 'Others';
      languageSpecific.putIfAbsent(category, () => []).add(song);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF3A0CA3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Search", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(backgroundColor: Colors.white),
          )
        ],
      ),
      body: allSongs.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          if (searchQuery.isNotEmpty)
            ...filteredSongs.map((song) => _buildSongTile(song)).toList()
          else ...[
            _buildSection("New Album", emotionalSongs.take(6).toList(), showAllSongs: emotionalSongs, isGrid: true),
            const SizedBox(height: 16),
            _buildSection("Popular Music", popularSongs.take(3).toList(), showAllSongs: popularSongs),
            const SizedBox(height: 16),
            Text("All Language Specific:",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 24.0),),
            for (var category in languageSpecific.keys)
              _buildSection("$category", languageSpecific[category]!.take(3).toList(), showAllSongs: languageSpecific[category]!),
          ]
        ],
      ),
      // bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      onChanged: _filterSongs,
      decoration: InputDecoration(
        hintText: "Search songs...",
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        filled: true,
        fillColor: Colors.deepPurple.shade300,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildSection(String title, List<dynamic> songs, {required List<dynamic> showAllSongs, bool isGrid = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold))),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SongListScreen(title: title, songs: showAllSongs.map((e) => Song.fromJson(e)).toList()),
                  ),
                );
              },
              child: const Text("See all", style: TextStyle(color: Colors.white70)),
            )
          ],
        ),
        isGrid
            ? GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: songs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.75),
          itemBuilder: (context, index) {
            return _buildAlbumCard(songs[index]);
          },
        )
            : Column(
          children: songs.map((song) => _buildSongTile(song)).toList(),
        ),
      ],
    );
  }

  Widget _buildAlbumCard(dynamic song) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(song),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(song['thumbnail'], height: 100, width: 100, fit: BoxFit.cover),
            ),
            const SizedBox(height: 4),
            Text(song['song_title'], style: const TextStyle(color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildSongTile(dynamic song) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(song['thumbnail'], width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(song['song_title'], style: const TextStyle(color: Colors.white)),
      subtitle: Text((song['singers'] as List).join(', '), style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.favorite_border, color: Colors.white),
      onTap: () => _navigateToPlayer(song),
    );
  }

  void _navigateToPlayer(dynamic song) {
    final selectedSong = Song.fromJson(song);
    final related = allSongs
        .where((s) => s['id'] != song['id'])
        .map((s) => Song.fromJson(s))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SongPlayerScreen(
          song: selectedSong,
          relatedSongs: related,
        ),
      ),
    );
  }

  // Widget _buildBottomBar() {
  //   return ClipRRect(
  //     borderRadius: const BorderRadius.only(
  //       topLeft: Radius.circular(12),
  //       topRight: Radius.circular(12),
  //     ),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: const Color(0xFF2A0A70).withOpacity(0.9), // Darker + transparent background
  //         border: const Border(
  //           top: BorderSide(color: Colors.white24, width: 0.5), // subtle top border
  //         ),
  //       ),
  //       child: Theme(
  //         data: Theme.of(context).copyWith(
  //           canvasColor: Colors.transparent,
  //           splashColor: Colors.transparent,
  //           highlightColor: Colors.transparent,
  //         ),
  //         child: BottomNavigationBar(
  //           backgroundColor: Colors.transparent,
  //           selectedItemColor: Colors.white,
  //           unselectedItemColor: Colors.white54,
  //           showSelectedLabels: false,
  //           showUnselectedLabels: false,
  //           items: const [
  //             BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
  //             BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
  //             BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
  //             BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

}
