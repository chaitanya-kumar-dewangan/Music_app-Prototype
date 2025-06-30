import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../data/music_data_model.dart';

class SongPlayerScreen extends StatefulWidget {
  final Song song;
  final List<Song> relatedSongs;

  const SongPlayerScreen({
    super.key,
    required this.song,
    required this.relatedSongs,
  });

  @override
  State<SongPlayerScreen> createState() => _SongPlayerScreenState();
}

class _SongPlayerScreenState extends State<SongPlayerScreen> {
  late YoutubePlayerController _controller;
  late Song _currentSong;
  bool _isPlaying = true;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(minutes: 3, seconds: 6);

  @override
  void initState() {
    super.initState();
    _currentSong = widget.song;
    _loadPlayer(_currentSong.audioUrl);
  }

  void _loadPlayer(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    _controller =
    YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: true,
        disableDragSeek: false,
        loop: true,
      ),
    )..addListener(() {
      if (mounted) {
        setState(() {
          _currentPosition = _controller.value.position;
        });
      }
    });
  }

  void _playSelectedSong(Song newSong) {
    setState(() {
      _currentSong = newSong;
      _controller.load(YoutubePlayer.convertUrlToId(newSong.audioUrl)!);
      _isPlaying = true;
      _currentPosition = Duration.zero;
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: false,
      ),
      builder: (context, player) => Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.withOpacity(0.4),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Column(
            children: [
              const Text(
                'Playing from Playlist',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
                _currentSong.mood, // Dynamic mood from current song
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          actions: const [
            Icon(Icons.headphones, color: Colors.white),
            SizedBox(width: 10.0),
          ],
        ),

        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(_currentSong.thumbnail, fit: BoxFit.cover),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.deepPurple.withOpacity(0.4)),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 180),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 20,
                                    sigmaY: 20,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      50,
                                      16,
                                      20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.15),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          _currentSong.songTitle,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _currentSong.singers.join(', '),
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          '**********',
                                          style: TextStyle(
                                            color: Colors.white30,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Tera mera rishta hai kaisa\nIk pal door gawara nahi\nTere liye har roz hai jeete\nTujh ko diya mera waqt sabhi\nKoi lamha mera na ho tere bina\nHar saans pe naam tera\n\nKyunki tum hi ho\nAb tum hi ho......',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                            height: 1.6,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(
                                _currentSong.thumbnail,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              height: 118,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: SingleChildScrollView(

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Smaller Slider & Label
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SliderTheme(
                                            data: SliderTheme.of(context).copyWith(
                                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                                              trackHeight: 2,
                                              activeTrackColor: Colors.deepPurple.shade700,
                                              inactiveTrackColor: Colors.white30,
                                              thumbColor: Colors.deepPurple,
                                            ),
                                            child: Slider(
                                              value: _currentPosition.inSeconds.toDouble(),
                                              max: _totalDuration.inSeconds.toDouble(),
                                              onChanged: (value) {
                                                _controller.seekTo(Duration(seconds: value.toInt()));
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        _formatDuration(_currentPosition),
                                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    // Smaller icons and spacing
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.favorite_border, color: Colors.white, size: 24),
                                        const SizedBox(width: 12),
                                        IconButton(
                                          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 24),
                                          onPressed: () {
                                            final currentIndex = widget.relatedSongs.indexOf(_currentSong);
                                            if (currentIndex > 0) {
                                              _playSelectedSong(widget.relatedSongs[currentIndex - 1]);
                                            }
                                          },
                                        ),
                                        const SizedBox(width: 4),
                                        IconButton(
                                          icon: Icon(
                                            _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                                            color: Colors.white,
                                            size: 38,
                                          ),
                                          onPressed: _togglePlayPause,
                                        ),
                                        const SizedBox(width: 4),
                                        IconButton(
                                          icon: const Icon(Icons.skip_next, color: Colors.white, size: 22),
                                          onPressed: () {
                                            final currentIndex = widget.relatedSongs.indexOf(_currentSong);
                                            if (currentIndex < widget.relatedSongs.length - 1) {
                                              _playSelectedSong(widget.relatedSongs[currentIndex + 1]);
                                            }
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(Icons.queue_music, color: Colors.white, size: 18),
                                      ],
                                    ),
                                    Opacity(
                                      opacity: 0,
                                      child: player,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.15,
                minChildSize: 0.15,
                maxChildSize: 0.6,
                builder: (context, scrollController) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final currentHeight = constraints.maxHeight;
                      final isExpanded = currentHeight > 150;

                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              border: Border.all(
                                color: Colors.white12,
                                width: 0.6,
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 4,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white38,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                const Text(
                                  'Next Playing',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: isExpanded
                                        ? widget.relatedSongs.length
                                        : (widget.relatedSongs.length >= 2
                                        ? 2
                                        : widget.relatedSongs.length),
                                    itemBuilder: (context, index) {
                                      final song = widget.relatedSongs[index];
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            song.thumbnail,
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        title: Text(
                                          song.songTitle,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          song.singers.join(', '),
                                          style: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 12,
                                          ),
                                        ),
                                        trailing: const Icon(
                                          Icons.more_vert,
                                          color: Colors.white54,
                                        ),
                                        onTap: () => _playSelectedSong(song),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
