import 'dart:convert';
import 'dart:ui';
import 'package:cinestreamtunes/screens/history_screen.dart';
import 'package:cinestreamtunes/screens/search_bar.dart';
import 'package:cinestreamtunes/services/playing_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/music_data_model.dart';
import '../services/player_provider.dart';
import 'favorite_screen.dart';
import 'mood_screen.dart';
import 'music_player screeen.dart';

class CinestreamtunesHome extends StatefulWidget {
  const CinestreamtunesHome({super.key});

  @override
  State<CinestreamtunesHome> createState() => _CinestreamtunesHomeState();
}

class _CinestreamtunesHomeState extends State<CinestreamtunesHome> {

  int _currentIndex = 0;

  final List<Widget> _screens = [
    CinestreamtunesHome(),
    SearchScreen(),
    FavoritesScreen(),
    HistoryScreen(),
  ];

  Map<String, List<Song>> categorizedSongs = {};

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    final String response = await rootBundle.loadString(
      'lib/data/music_all.json',
    );
    final List<dynamic> data = await json.decode(response);
    final List<Song> allSongs = data.map((e) => Song.fromJson(e)).toList();
    final Map<String, List<Song>> categorized = {};
    for (var song in allSongs) {
      final category = song.category.isNotEmpty ? song.category : 'Others';
      categorized.putIfAbsent(category, () => []).add(song);
    }
    setState(() {
      categorizedSongs = categorized;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5D2EDE),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const NowPlayingBar(), // 🔥 Shows only when a song is active
          Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade700,
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white54,
                  currentIndex: _currentIndex,
                  onTap: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, size: 32),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search, size: 32),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border, size: 32),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.library_music_rounded, size: 32),
                      label: '',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBodyByIndex(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _nowPlayingCard(),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    const double expandedHeight = 210;
    const double collapsedHeight = 93;

    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      backgroundColor: const Color(0xFF5D2EDE),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double percent =
          ((constraints.maxHeight - collapsedHeight) /
              (expandedHeight - collapsedHeight))
              .clamp(0.0, 1.0);

          final double avatarSize = 34 + (56 - 34) * percent;
          final double nameFontSize = 14 + (22 - 14) * percent;
          final double subFontSize = 10 + (16 - 10) * percent;
          final double chipFontSize = 10 + (13 - 10) * percent;
          final double chipHeight = 26 + (36 - 26) * percent;
          final double spacing = 4 + (12 - 4) * percent;

          final bool isCollapsed = percent < 0.5;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C48FF), Color(0xFF3621B7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 36, 8, 8),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: collapsedHeight - 36, // ensure enough room
                      maxHeight: expandedHeight - 36,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isCollapsed) ...[
                          Row(
                            children: [
                              CircleAvatar(
                                radius: avatarSize / 2,
                                backgroundImage: const AssetImage(
                                  'assets/cover.jpg',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hello Chaitanya! 👋",
                                    style: TextStyle(
                                      fontSize: nameFontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Ready To Vibe?”",
                                    style: TextStyle(
                                      fontSize: subFontSize,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                                size: 30,
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                        ] else
                          ...[
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: avatarSize / 2,
                                  backgroundImage: const AssetImage(
                                    'assets/cover.jpg',
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.notifications_none,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                            SizedBox(height: spacing),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello Chaitanya! 👋",
                                  style: TextStyle(
                                    fontSize: nameFontSize,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Ready To Vibe?”",
                                  style: TextStyle(
                                    fontSize: subFontSize,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: spacing),
                          ],
                        SizedBox(
                          height: chipHeight,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            children: _buildMoodChips(fontSize: chipFontSize),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildMoodChips({double fontSize = 12}) {
    final Set<String> moods = categorizedSongs.values
        .expand((songs) => songs.map((s) => s.mood))
        .toSet();

    return moods.map((mood) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  MoodSongsScreen(
                    mood: mood,
                    categorizedSongs: categorizedSongs,
                  ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Text(
                  mood,
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBodyByIndex() {
    switch (_currentIndex) {
      case 0:
        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(child: _buildScrollableContent()),
            const SliverToBoxAdapter(child: SizedBox(height: 75)),
          ],
        );
      case 1:
        return SearchScreen();
    // return Center(child: Text("Search Screen"));
      case 2:
        return FavoritesScreen();
    // return Center(child: Text("Favorites Screen"));
      case 3:
        return HistoryScreen();
      default:
        return Center(child: Text("Unknown Screen"));
    }
  }

  Widget _buildScrollableContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categorizedSongs.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_sectionTitle(entry.key), _horizontalList(entry.value)],
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _horizontalList(List<Song> songs) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];

          return GestureDetector(
            onTap: () {
              final allSongs = categorizedSongs.values
                  .expand((s) => s)
                  .toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SongPlayerScreen(
                        song: song,
                        relatedSongs: allSongs
                            .where((s) =>
                        s.mood == song.mood && s.id != song.id)
                            .toList(),
                      ),
                ),
              );
            },

            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Image.network(
                    song.thumbnail,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                    const Center(
                      child: Icon(Icons.broken_image, color: Colors.white54),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      song.songTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '🎵 ${song.singers.first}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.play_circle_fill,
                                size: 28,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _nowPlayingCard() =>
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 73.0,
            padding: const EdgeInsets.symmetric(
                horizontal: 12.0, vertical: 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent.withOpacity(0.25),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                  color: Colors.white.withOpacity(0.2), width: 1.2),
            ),
            child: Row(
              children: [
                const Icon(Icons.graphic_eq, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tum Hi Ho",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Arijit Singh",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Stack(
                        children: [
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Container(
                            height: 4,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "3:06",
                          style: TextStyle(color: Colors.white54, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.pause_circle_filled,
                  color: Colors.white,
                  size: 36,
                ),
              ],
            ),
          ),
        ),
      );


// Widget nowPlayingCard(BuildContext context) {
//   final player = Provider.of<YoutubePlayerProvider>(context);
//   final song = player.currentSong;
//   final controller = player.controller;
//
//   if (song == null || controller == null || !player.isPlayerReady) {
//     return const SizedBox();
//   }
//
//   final duration = controller.metadata.duration;
//   final position = controller.value.position;
//
//   final progress = duration.inSeconds > 0
//       ? position.inSeconds / duration.inSeconds
//       : 0.0;
//
//   return GestureDetector(
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => SongPlayerScreen(
//             song: song,
//             relatedSongs: [], // Pass actual related songs if available
//           ),
//         ),
//       );
//     },
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//         child: Container(
//           height: 73.0,
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: LinearGradient(
//               colors: [
//                 Colors.deepPurpleAccent.withOpacity(0.25),
//                 Colors.white.withOpacity(0.05),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.2),
//           ),
//           child: Row(
//             children: [
//               const Icon(Icons.graphic_eq, color: Colors.white, size: 28),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       song.songTitle,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     Text(
//                       song.singers.join(', '),
//                       style: const TextStyle(color: Colors.white70, fontSize: 12),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Stack(
//                       children: [
//                         Container(
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: Colors.white24,
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                         FractionallySizedBox(
//                           widthFactor: progress.clamp(0.0, 1.0),
//                           child: Container(
//                             height: 4,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(2),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 2),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: Text(
//                         _formatDuration(duration),
//                         style: const TextStyle(color: Colors.white54, fontSize: 10),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 12),
//               IconButton(
//                 icon: Icon(
//                   player.isPlaying
//                       ? Icons.pause_circle_filled
//                       : Icons.play_circle_fill,
//                   color: Colors.white,
//                   size: 36,
//                 ),
//                 onPressed: player.togglePlayPause,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// String _formatDuration(Duration duration) {
//   final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
//   final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
//   return "$minutes:$seconds";
// }


}
