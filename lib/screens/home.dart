// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../data/music_data_model.dart';
// import 'mood_screen.dart';
// import 'music_player screeen.dart';
//
// class CinestreamtunesHome extends StatefulWidget {
//   const CinestreamtunesHome({super.key});
//
//   @override
//   State<CinestreamtunesHome> createState() => _CinestreamtunesHomeState();
// }
//
// class _CinestreamtunesHomeState extends State<CinestreamtunesHome> {
//   Map<String, List<Song>> categorizedSongs = {};
//
//   @override
//   void initState() {
//     super.initState();
//     loadSongs();
//   }
//
//   Future<void> loadSongs() async {
//     final String response = await rootBundle.loadString(
//       'lib/data/music_all.json',
//     );
//     final List<dynamic> data = await json.decode(response);
//     final List<Song> allSongs = data.map((e) => Song.fromJson(e)).toList();
//     final Map<String, List<Song>> categorized = {};
//     for (var song in allSongs) {
//       final category = song.category.isNotEmpty ? song.category : 'Others';
//       categorized.putIfAbsent(category, () => []).add(song);
//     }
//     setState(() {
//       categorizedSongs = categorized;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF5D2EDE),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.deepPurple.shade700,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white54,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
//         ],
//       ),
//       body: Stack(
//         children: [
//           CustomScrollView(
//             slivers: [
//               _buildSliverAppBar(),
//               SliverToBoxAdapter(child: _buildScrollableContent()),
//               const SliverToBoxAdapter(child: SizedBox(height: 75)),
//             ],
//           ),
//           Positioned(left: 0, right: 0, bottom: 0, child: _nowPlayingCard()),
//         ],
//       ),
//     );
//   }
//
//   SliverAppBar _buildSliverAppBar() {
//     const double expandedHeight = 210;
//     const double collapsedHeight = 93;
//
//     return SliverAppBar(
//       pinned: true,
//       expandedHeight: expandedHeight,
//       collapsedHeight: collapsedHeight,
//       backgroundColor: const Color(0xFF5D2EDE),
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       flexibleSpace: LayoutBuilder(
//         builder: (context, constraints) {
//           final double percent =
//               ((constraints.maxHeight - collapsedHeight) /
//                       (expandedHeight - collapsedHeight))
//                   .clamp(0.0, 1.0);
//
//           final double avatarSize = 34 + (56 - 34) * percent;
//           final double nameFontSize = 14 + (22 - 14) * percent;
//           final double subFontSize = 10 + (16 - 10) * percent;
//           final double chipFontSize = 10 + (13 - 10) * percent;
//           final double chipHeight = 26 + (36 - 26) * percent;
//           final double spacing = 4 + (12 - 4) * percent;
//
//           final bool isCollapsed = percent < 0.5;
//
//           return Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF6C48FF), Color(0xFF3621B7)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Align(
//               alignment: Alignment.bottomLeft,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(8, 36, 8, 8),
//                 child: SingleChildScrollView(
//                   physics: const NeverScrollableScrollPhysics(),
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: collapsedHeight - 36, // ensure enough room
//                       maxHeight: expandedHeight - 36,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (isCollapsed) ...[
//                           Row(
//                             children: [
//                               CircleAvatar(
//                                 radius: avatarSize / 2,
//                                 backgroundImage: const AssetImage(
//                                   'assets/cover.jpg',
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Hello Priya! 👋",
//                                     style: TextStyle(
//                                       fontSize: nameFontSize,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Ready To Vibe?”",
//                                     style: TextStyle(
//                                       fontSize: subFontSize,
//                                       color: Colors.white70,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const Spacer(),
//                               const Icon(
//                                 Icons.notifications_none,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: spacing),
//                         ] else ...[
//                           Row(
//                             children: [
//                               CircleAvatar(
//                                 radius: avatarSize / 2,
//                                 backgroundImage: const AssetImage(
//                                   'assets/cover.jpg',
//                                 ),
//                               ),
//                               const Spacer(),
//                               const Icon(
//                                 Icons.notifications_none,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: spacing),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Hello Priya! 👋",
//                                 style: TextStyle(
//                                   fontSize: nameFontSize,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 "Ready To Vibe?”",
//                                 style: TextStyle(
//                                   fontSize: subFontSize,
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: spacing),
//                         ],
//                         SizedBox(
//                           height: chipHeight,
//                           child: ListView(
//                             scrollDirection: Axis.horizontal,
//                             padding: EdgeInsets.zero,
//                             children: _buildMoodChips(fontSize: chipFontSize),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   List<Widget> _buildMoodChips({double fontSize = 12}) {
//     final Set<String> moods = categorizedSongs.values
//         .expand((songs) => songs.map((s) => s.mood))
//         .toSet();
//
//     return moods.map((mood) {
//       return GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => MoodSongsScreen(
//                 mood: mood,
//                 categorizedSongs: categorizedSongs,
//               ),
//             ),
//           );
//         },
//         child: Container(
//           margin: const EdgeInsets.only(right: 8),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.white.withOpacity(0.2)),
//                 ),
//                 child: Text(
//                   mood,
//                   style: TextStyle(color: Colors.white, fontSize: fontSize),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }
//
//   Widget _buildScrollableContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: categorizedSongs.entries.map((entry) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [_sectionTitle(entry.key), _horizontalList(entry.value)],
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//       child: Text(
//         title,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   Widget _horizontalList(List<Song> songs) {
//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         itemCount: songs.length,
//         itemBuilder: (context, index) {
//           final song = songs[index];
//
//           return GestureDetector(
//             onTap: () {
//               final allSongs = categorizedSongs.values.expand((s) => s).toList();
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SongPlayerScreen(
//                     song: song,
//                     relatedSongs: allSongs
//                         .where((s) => s.mood == song.mood && s.id != song.id)
//                         .toList(),
//                   ),
//                 ),
//               );
//             },
//
//             child: Container(
//               width: 140,
//               margin: const EdgeInsets.only(right: 8),
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
//               clipBehavior: Clip.antiAlias,
//               child: Stack(
//                 children: [
//                   Image.network(
//                     song.thumbnail,
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return const Center(
//                         child: CircularProgressIndicator(color: Colors.white),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) => const Center(
//                       child: Icon(Icons.broken_image, color: Colors.white54),
//                     ),
//                   ),
//                   Positioned(
//                     left: 0,
//                     right: 0,
//                     bottom: 0,
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(20),
//                         bottomRight: Radius.circular(20),
//                       ),
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                           ),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       song.songTitle,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     Text(
//                                       '🎵 ${song.singers.first}',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(
//                                         color: Colors.white70,
//                                         fontSize: 11,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Icon(
//                                 Icons.play_circle_fill,
//                                 size: 28,
//                                 color: Colors.white,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//   Widget _nowPlayingCard() => ClipRRect(
//     borderRadius: BorderRadius.circular(12),
//     child: BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//       child: Container(
//         height: 73.0,
//         padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           gradient: LinearGradient(
//             colors: [
//               Colors.deepPurpleAccent.withOpacity(0.25),
//               Colors.white.withOpacity(0.05),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.2),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.graphic_eq, color: Colors.white, size: 28),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Tum Hi Ho",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Text(
//                     "Arijit Singh",
//                     style: TextStyle(color: Colors.white70, fontSize: 12),
//                   ),
//                   const SizedBox(height: 4),
//                   Stack(
//                     children: [
//                       Container(
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: Colors.white24,
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                       Container(
//                         height: 4,
//                         width: 120,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 2),
//                   const Align(
//                     alignment: Alignment.bottomRight,
//                     child: Text(
//                       "3:06",
//                       style: TextStyle(color: Colors.white54, fontSize: 10),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Icon(
//               Icons.pause_circle_filled,
//               color: Colors.white,
//               size: 36,
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/music_data_model.dart';
import 'mood_screen.dart';
import 'music_player screeen.dart';

class CinestreamtunesHome extends StatefulWidget {
  const CinestreamtunesHome({super.key});

  @override
  State<CinestreamtunesHome> createState() => _CinestreamtunesHomeState();
}

class _CinestreamtunesHomeState extends State<CinestreamtunesHome> {
  Map<String, List<Song>> categorizedSongs = {};

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    final String response = await rootBundle.loadString('lib/data/music_all.json');
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple.shade700,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(child: _buildScrollableContent()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          Positioned(left: 12, right: 12, bottom: 12, child: _nowPlayingCard()),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    // unchanged
    // (same as your code)
    // ...
    return SliverAppBar(
      pinned: true,
      expandedHeight: 210,
      collapsedHeight: 93,
      backgroundColor: const Color(0xFF5D2EDE),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double percent =
          ((constraints.maxHeight - 93) / (210 - 93)).clamp(0.0, 1.0);
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
                      minHeight: 93 - 36,
                      maxHeight: 210 - 36,
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
                                backgroundImage: const AssetImage('assets/cover.jpg'),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hello Priya! 👋", style: TextStyle(fontSize: nameFontSize, color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text("Ready To Vibe?", style: TextStyle(fontSize: subFontSize, color: Colors.white70)),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.notifications_none, color: Colors.white, size: 30),
                            ],
                          ),
                          SizedBox(height: spacing),
                        ] else ...[
                          Row(
                            children: [
                              CircleAvatar(
                                radius: avatarSize / 2,
                                backgroundImage: const AssetImage('assets/cover.jpg'),
                              ),
                              const Spacer(),
                              const Icon(Icons.notifications_none, color: Colors.white, size: 30),
                            ],
                          ),
                          SizedBox(height: spacing),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hello Priya! 👋", style: TextStyle(fontSize: nameFontSize, color: Colors.white, fontWeight: FontWeight.bold)),
                              Text("Ready To Vibe?", style: TextStyle(fontSize: subFontSize, color: Colors.white70)),
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
    final Set<String> moods = categorizedSongs.values.expand((songs) => songs.map((s) => s.mood)).toSet();

    return moods.map((mood) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MoodSongsScreen(
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Text(mood, style: TextStyle(color: Colors.white, fontSize: fontSize)),
              ),
            ),
          ),
        ),
      );
    }).toList();
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
              final allSongs = categorizedSongs.values.expand((s) => s).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongPlayerScreen(
                    song: song,
                    relatedSongs: allSongs.where((s) => s.mood == song.mood && s.id != song.id).toList(),
                  ),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    },
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.white54),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15)),
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

  Widget _nowPlayingCard() => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        height: 73.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
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
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.2),
        ),
        child: Row(
          children: [
            const Icon(Icons.graphic_eq, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Tum Hi Ho", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("Arijit Singh", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: 0.4,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.pause_circle_filled, color: Colors.white, size: 36),
          ],
        ),
      ),
    ),
  );
}
