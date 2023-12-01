import 'dart:convert';
import 'package:movies_app/api/api.dart';
import 'package:movies_app/models/actor_movies.dart';
import 'package:movies_app/models/actor_biography.dart';
import 'package:movies_app/models/actor.dart';
import 'package:movies_app/models/review.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Actor>?> getTopRatedActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/popular?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].take(10).forEach(
        (m) => actors.add(
          Actor.fromMap(m),
        ),
      );
      return actors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Actor>?> getTrendingActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}trending/person/day?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => actors.add(
              Actor.fromMap(m),
            ),
          );
      return actors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Actor>?> getPopularActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/popular?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => actors.add(
              Actor.fromMap(m),
            ),
          );
      return actors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Actor>?> getSearchedActors(String query) async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}search/person?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => actors.add(
          Actor.fromMap(m),
        ),
      );
      return actors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']),
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }

  static Future<List<ActorMovies>> getActorMovie(String actorName) async {
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}search/person?api_key=${Api.apiKey}&language=en-US&page=1&query=$actorName&include_adult=false'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> results = responseData['results'];

        final actor = results.firstWhere(
          (personData) => personData['name']
              .toString()
              .toLowerCase()
              .contains(actorName.toLowerCase()),
          orElse: () => null,
        );

        if (actor != null) {
          final List<dynamic> knownFor = actor['known_for'];

          return knownFor
              .where((movieData) => movieData['media_type'] == 'movie')
              .map<ActorMovies>((movieData) => ActorMovies(
                    id: movieData['id'] as int,
                    title: movieData['title'] ?? '',
                    posterPath: movieData['poster_path'] ?? '',
                    backdropPath: movieData['backdrop_path'] ?? '',
                    overview: movieData['overview'] ?? '',
                    releaseDate: movieData['release_date'] ?? '',
                    popularity: movieData['popularity'] ?? '',
                    voteAverage: movieData['vote_average'] ?? '',
                    genreIds: List<int>.from(movieData['genre_ids']),
                  ))
              .toList();
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<ActorBiography?> getActorBiography(int actorId) async {
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/$actorId?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);

      return ActorBiography(
        id: res['id'],
        biography: res['biography'],
      );
    } catch (e) {
      return null;
    }
  }
}
