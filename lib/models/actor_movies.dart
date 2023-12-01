import 'dart:convert';

class ActorMovies {
  int id;
  String title;
  String posterPath;
  String backdropPath;
  String overview;
  String releaseDate;
  double popularity;
  double voteAverage;
  List<int> genreIds;


  ActorMovies({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
    required this.releaseDate,
    required this.popularity,
    required this.voteAverage,
    required this.genreIds,
  }); 

  factory ActorMovies.fromMap(Map<String, dynamic> map) {
    return ActorMovies(
      id: map['id'] as int,
      title: map['title'] ?? '',
      posterPath: map['poster_path'] ?? '',
      backdropPath: map['backdrop_path'] ?? '',
      overview: map['overview'] ?? '',
      releaseDate: map['release_date'] ?? '',
      popularity: map['popularity']?.toDouble() ?? 0.0,
      voteAverage: map['vote_average']?.toDouble() ?? 0.0,
      genreIds: List<int>.from(map['genre_ids']),
    );
  }

  factory ActorMovies.fromJson(String source) => ActorMovies.fromMap(json.decode(source));

  String getFoto() {
    return posterPath.isEmpty
        ? 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg'
        : Uri.https('image.tmdb.org', '/t/p/w500/$posterPath').toString();
  }
}
