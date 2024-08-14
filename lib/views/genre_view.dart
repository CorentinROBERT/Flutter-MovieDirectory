import 'package:flutter/material.dart';
import 'package:movie_directory/models/genre.dart';

class GenreView extends StatelessWidget {
  Genre genre;

  GenreView({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(genre.name));
  }
}
