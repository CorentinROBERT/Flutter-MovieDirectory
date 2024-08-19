import 'package:flutter/material.dart';
import 'package:movie_directory/models/response_list_movie.dart';
import 'package:movie_directory/services/api_service.dart';
import 'package:movie_directory/views/details_movie.dart';

class CarouselMovie extends StatelessWidget {
  Movie movie;
  CarouselMovie({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailsMovie(movie: movie)));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Image.network(
          "${ApiService().imageUrl}${movie.posterPath}",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
