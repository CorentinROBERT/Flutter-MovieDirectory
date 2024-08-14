import 'package:flutter/material.dart';
import 'package:movie_directory/models/response_list_genre.dart';
import 'package:movie_directory/models/response_list_movie.dart';
import 'package:movie_directory/services/api_service.dart';

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
                  SizedBox(
                    height: size.height / 4,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: ((context, index) => SizedBox(
                            width: 150,
                            height: 200,
                            child: Card(
                              elevation: 7,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Image.network(
                                      "${ApiService().imageUrl}${movies!.results[index].posterPath}",
                                      height: 150,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        movies!.results[index].title,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ]),
                            ),
                          )),
                      itemCount: movies?.results.length,
                    ),
                  ),
                  if (genres != null && genres!.genres.isNotEmpty)
                    SizedBox(
                      height: size.height / 2.4,
                      child: ListView.builder(
                        itemBuilder: ((context, index) =>
                            Text(genres!.genres[index].name)),
                        itemCount: genres!.genres.length,
                      ),
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
