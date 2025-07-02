import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../data/music_data_model.dart';

class YoutubePlayerProvider extends ChangeNotifier {
  YoutubePlayerController? controller;
  Song? currentSong;
  bool isPlayerReady = false;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;

  void initController(Song song) {
    final videoId = YoutubePlayer.convertUrlToId(song.audioUrl);
    if (videoId == null) {
      isPlayerReady = false;
      notifyListeners();
      return;
    }

    controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        hideControls: true,
      ),
    )..addListener(_listener);

    currentSong = song;

    // Wait for controller to be ready
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (controller!.value.isReady) {
        isPlayerReady = true;
        isPlaying = true;
        notifyListeners();
      }
    });
  }

  void _listener() {
    if (controller == null) return;
    currentPosition = controller!.value.position;
    isPlaying = controller!.value.isPlaying;
    notifyListeners();
  }

  void setCurrentSong(Song song) {
    final videoId = YoutubePlayer.convertUrlToId(song.audioUrl);
    if (videoId == null || controller == null) return;

    controller!.load(videoId);
    currentSong = song;
    isPlaying = true;
    currentPosition = Duration.zero;

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (controller!.value.isReady) {
        isPlayerReady = true;
        notifyListeners();
      }
    });
  }

  void togglePlayPause() {
    if (controller == null) return;

    if (isPlaying) {
      controller!.pause();
    } else {
      controller!.play();
    }

    isPlaying = !isPlaying;
    notifyListeners();
  }

  void seekTo(Duration position) {
    controller?.seekTo(position);
    currentPosition = position;
    notifyListeners();
  }

  void disposeController() {
    controller?.dispose();
    controller = null;
    isPlayerReady = false;
    isPlaying = false;
    currentSong = null;
    currentPosition = Duration.zero;
    notifyListeners();
  }
}
