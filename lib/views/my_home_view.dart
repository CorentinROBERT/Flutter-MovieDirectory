import 'package:flutter/material.dart';
import 'package:movie_directory/models/response_list_genre.dart';
import 'package:movie_directory/models/response_list_movie.dart';
import 'package:movie_directory/services/api_service.dart';
import 'package:movie_directory/views/genre_view.dart';
import 'package:movie_directory/views/top_rated_movie_view.dart';

class MyHomeView extends StatefulWidget {
  const MyHomeView({super.key});

  @override
  State<StatefulWidget> createState() => MyHomeState();
}

class MyHomeState extends State<MyHomeView> {
  ResponseListMovie? movies;
  ResponseListGenre? genres;

  @override
  void initState() {
    updateTop20Movie();
    updateGenres();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Movie Directory"),
      ),
      body: (movies == null || movies!.results.isEmpty)
          ? const Center(child: Text("no datas"))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Top 20 movie 🍿",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: size.height / 4,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: ((context, index) => SizedBox(
                          width: 150,
                          height: 200,
                          child: TopRatedMovieView(
                              movie: movies!.results[index]))),
                      itemCount: movies?.results.length,
                    ),
                  ),
                  if (genres != null && genres!.genres.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text("Genres ",
                              style: Theme.of(context).textTheme.headlineLarge),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Wrap(
                            spacing: 5.0,
                            direction: Axis.horizontal,
                            children: genres!.genres
                                .map((genre) => GenreView(genre: genre))
                                .toList(),
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox()
                ],
              ),
            ),
    );
  }

  void updateTop20Movie() async {
    try {
      movies = await ApiService().getMovieTopRated();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void updateGenres() async {
    try {
      genres = await ApiService().getGenres();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
