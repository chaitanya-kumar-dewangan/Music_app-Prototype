// //
// // import 'package:flutter/cupertino.dart';
// // import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// //
// // import '../data/music_data_model.dart';
// //
// // class YoutubePlayerProvider with ChangeNotifier {
// //   YoutubePlayerController? _controller;
// //   Song? _currentSong;
// //   bool _isPlayerReady = false;
// //   Duration _currentPosition = Duration.zero;
// //
// //   YoutubePlayerController? get controller => _controller;
// //   Song? get currentSong => _currentSong;
// //   bool get isPlaying => _controller?.value.isPlaying ?? false;
// //   bool get isPlayerReady => _isPlayerReady;
// //   Duration get currentPosition => _currentPosition;
// //
// //   void initController(Song song) {
// //     final videoId = YoutubePlayer.convertUrlToId(song.audioUrl);
// //     if (videoId == null) return;
// //
// //     _controller = YoutubePlayerController(
// //       initialVideoId: videoId,
// //       flags: const YoutubePlayerFlags(
// //         autoPlay: true,
// //         mute: false,
// //         loop: true,
// //         hideControls: true,
// //       ),
// //     )..addListener(_listener);
// //
// //     _currentSong = song;
// //     _isPlayerReady = true;
// //     notifyListeners();
// //   }
// //
// //   void _listener() {
// //     if (_controller?.value.isReady ?? false && !(_controller?.value.hasError ?? true)) {
// //       _currentPosition = _controller!.value.position;
// //       notifyListeners();
// //     }
// //   }
// //
// //   void setCurrentSong(Song song) {
// //     final videoId = YoutubePlayer.convertUrlToId(song.audioUrl);
// //     if (videoId == null || videoId == _controller?.initialVideoId) return;
// //
// //     _currentSong = song;
// //
// //     if (_controller != null && _isPlayerReady) {
// //       _controller!.load(videoId);
// //     } else {
// //       initController(song);
// //     }
// //
// //     notifyListeners();
// //   }
// //
// //   void togglePlayPause() {
// //     if (!isPlayerReady) return;
// //     isPlaying ? _controller!.pause() : _controller!.play();
// //     notifyListeners();
// //   }
// //
// //   void play() {
// //     if (isPlayerReady) _controller!.play();
// //   }
// //
// //   void pause() {
// //     if (isPlayerReady) _controller!.pause();
// //   }
// //
// //   void seekTo(Duration position) {
// //     if (isPlayerReady) _controller!.seekTo(position);
// //   }
// //
// //   void disposeController() {
// //     _controller?.removeListener(_listener);
// //     _controller?.dispose();
// //     _controller = null;
// //     _isPlayerReady = false;
// //   }
// // }
//
// // --- YoutubePlayerProvider (player_provider.dart) ---
//
// import 'package:flutter/cupertino.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import '../data/music_data_model.dart';
//
// class YoutubePlayerProvider with ChangeNotifier {
//   YoutubePlayerController? _controller;
//   Song? _currentSong;
//   bool _isPlayerReady = false;
//   Duration _currentPosition = Duration.zero;
//
//   YoutubePlayerController? get controller => _controller;
//   Song? get currentSong => _currentSong;
//   bool get isPlaying => _controller?.value.isPlaying ?? false;
//   bool get isPlayerReady => _isPlayerReady;
//   Duration get currentPosition => _currentPosition;
//
//   void initController(Song song) {
//     final videoId = YoutubePlayer.convertUrlToId(song.audioUrl);
//     if (videoId == null) return;
//
//     _controller = YoutubePlayerController(
//       initialVideoId: videoId,
//       flags: const YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//         loop: true,
//         hideControls: true,
//       ),
//     )..addListener(_listener);
//
//     _currentSong = song;
//     _isPlayerReady = false;
//     notifyListeners();
//   }
//
//   void _listener() {
//     if (_controller?.value.isReady ?? false) {
//       _currentPosition = _controller!.value.position;
//       if (!_isPlayerReady) {
//         _isPlayerReady = true;
//         notifyListeners();
//       }
//     }
//   }
//
//   void setCurrentSong(Song song) {
//     final videoId = YoutubePlayer.convertUrlToId(song.audioUrl);
//     if (videoId == null) return;
//
//     _currentSong = song;
//
//     if (_controller != null) {
//       _controller!.load(videoId);
//     } else {
//       initController(song);
//     }
//     notifyListeners();
//   }
//
//   void togglePlayPause() {
//     if (!_isPlayerReady || _controller == null) return;
//     isPlaying ? _controller!.pause() : _controller!.play();
//     notifyListeners();
//   }
//
//   void seekTo(Duration position) {
//     if (_isPlayerReady && _controller != null) {
//       _controller!.seekTo(position);
//     }
//   }
//
//   void disposeController() {
//     _controller?.removeListener(_listener);
//     _controller?.dispose();
//     _controller = null;
//     _isPlayerReady = false;
//     notifyListeners();
//   }
// }
//
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
