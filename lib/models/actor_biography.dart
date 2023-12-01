import 'dart:convert';

class ActorBiography {
  int id;
  String biography;
  
  ActorBiography({
    required this.id,
    required this.biography,
    
  });

  factory ActorBiography.fromMap(Map<String, dynamic> map) {
    return ActorBiography(
      id: map['id'] as int,
      biography: map['biography'] ?? '',
    );
  }

  factory ActorBiography.fromJson(String source) => ActorBiography.fromMap(json.decode(source));
}
