import 'package:flutter/material.dart';
import 'package:movie_directory/models/response_list_movie.dart';
import 'package:movie_directory/services/api_service.dart';

class TopRatedMovieView extends StatelessWidget {
  Movie movie;
  TopRatedMovieView({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              "${ApiService().imageUrl}${movie.posterPath}",
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                movie.title,
                textAlign: TextAlign.center,
              ),
            ),
          ]),
    );
  }
}
