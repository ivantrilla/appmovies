import 'dart:convert';
import 'package:movies_app/models/actor_movies.dart';

class Actor {
  int id;
  String name;
  String profilePath;
  String knownForDepartment;
  double popularity;
  List<ActorMovies> actorMovies;

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.knownForDepartment,
    required this.popularity,
    required this.actorMovies,

  });

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      id: map['id'] as int,
      name: map['name'] ?? '',
      profilePath: map['profile_path'] ?? '',
      knownForDepartment: map['known_for_department'] ?? '',
      popularity: map['popularity']?.toDouble() ?? 0.0,
      actorMovies: [],

    );
  }

  factory Actor.fromJson(String source) => Actor.fromMap(json.decode(source));
}

