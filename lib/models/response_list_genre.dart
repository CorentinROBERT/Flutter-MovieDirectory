import 'dart:convert';

import 'package:movie_directory/models/genre.dart';

class ResponseListGenre {
  List<Genre> genres;

  ResponseListGenre({
    required this.genres,
  });

  factory ResponseListGenre.fromJson(Map<String, dynamic> json) {
    return ResponseListGenre(
      genres: List<Genre>.from(json['genres'].map((x) => Genre.fromJson(x))),
    );
  }
}
