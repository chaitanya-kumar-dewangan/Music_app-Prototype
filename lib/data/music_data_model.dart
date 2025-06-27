// class Song {
//   final String id;
//   final String songTitle;
//   final List<String> singers;
//   final String genre;
//   final int year;
//   final String audioUrl;
//   final String thumbnail;
//   final String movieName;
//   final String regional;
//   final String duration;
//   final String mood;
//   final String category;
//
//   Song({
//     required this.id,
//     required this.songTitle,
//     required this.singers,
//     required this.genre,
//     required this.year,
//     required this.audioUrl,
//     required this.thumbnail,
//     required this.movieName,
//     required this.regional,
//     required this.duration,
//     required this.mood,
//     required this.category,
//   });
//
//   factory Song.fromJson(Map<String, dynamic> json) {
//     return Song(
//       id: json['id'] as String,
//       songTitle: json['song_title'] as String,
//       singers: List<String>.from(json['singers']),
//       genre: json['genre'] as String,
//       year: json['year'] as int,
//       audioUrl: json['audio_url'] as String,
//       thumbnail: json['thumbnail'] as String,
//       movieName: json['movie_name'] as String,
//       regional: json['regional'] as String,
//       duration: json['duration'] as String,
//       mood: json['mood'] as String,
//       category: json['category'] as String,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'song_title': songTitle,
//       'singers': singers,
//       'genre': genre,
//       'year': year,
//       'audio_url': audioUrl,
//       'thumbnail': thumbnail,
//       'movie_name': movieName,
//       'regional': regional,
//       'duration': duration,
//       'mood': mood,
//       'category': category,
//     };
//   }
// }

class Song {
  final String id;
  final String songTitle;
  final List<String> singers;
  final String genre;
  final int year;
  final String audioUrl;
  final String thumbnail;
  final String movieName;
  final String regional;
  final String duration;
  final String mood;
  final String category;

  Song({
    required this.id,
    required this.songTitle,
    required this.singers,
    required this.genre,
    required this.year,
    required this.audioUrl,
    required this.thumbnail,
    required this.movieName,
    required this.regional,
    required this.duration,
    required this.mood,
    required this.category,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as String,
      songTitle: json['song_title'] as String,
      singers: List<String>.from(json['singers']),
      genre: json['genre'] as String,
      year: json['year'] as int,
      audioUrl: json['audio_url'] as String,
      thumbnail: json['thumbnail'] as String,
      movieName: json['movie_name'] as String,
      regional: json['regional'] as String,
      duration: json['duration'] as String,
      mood: json['mood'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'song_title': songTitle,
      'singers': singers,
      'genre': genre,
      'year': year,
      'audio_url': audioUrl,
      'thumbnail': thumbnail,
      'movie_name': movieName,
      'regional': regional,
      'duration': duration,
      'mood': mood,
      'category': category,
    };
  }
}
