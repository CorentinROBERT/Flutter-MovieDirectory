import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_directory/models/genre.dart';
import 'package:movie_directory/models/response_list_genre.dart';
import 'package:movie_directory/models/response_list_movie.dart';
import 'package:movie_directory/services/api_service.dart';
import 'package:movie_directory/views/genre_view.dart';
import 'package:movie_directory/views/movie_template/carousel_movie.dart';
import 'package:movie_directory/views/movie_template/top_rated_movie_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyHomeView extends StatefulWidget {
  const MyHomeView({super.key});

  @override
  State<StatefulWidget> createState() => MyHomeState();
}

class MyHomeState extends State<MyHomeView> {
  ResponseListMovie? movies;
  ResponseListMovie? popularMovies;
  ResponseListMovie? upcomingMovies;

  ResponseListGenre? genres;
  ResponseListMovie? recommendedMovies;
  List<int> selectedGenres = [];

  @override
  void initState() {
    updateTop20Movie();
    updatePopularMovie();
    updateUpcomingMovie();
    updateGenres();
    updateRecommendedMovie([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(AppLocalizations.of(context)!.app_title),
      ),
      body: (movies == null || movies!.results.isEmpty)
          ? Center(child: Text(AppLocalizations.of(context)!.no_data))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      AppLocalizations.of(context)!.top_20_movie,
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
                  popularMovies != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.most_popular,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                height: size.height / 2.5,
                                child: CarouselSlider(
                                  items: popularMovies!.results
                                      .map((e) => CarouselMovie(movie: e))
                                      .toList(),
                                  options: CarouselOptions(
                                    height: size.height / 3,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 0.5,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.3,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  upcomingMovies != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                AppLocalizations.of(context)!.upcoming,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
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
                                        movie:
                                            upcomingMovies!.results[index]))),
                                itemCount: upcomingMovies?.results.length,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  if (genres != null && genres!.genres.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(AppLocalizations.of(context)!.genre,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Wrap(
                                spacing: 5.0,
                                direction: Axis.horizontal,
                                children: genres!.genres
                                    .map((genre) => GenreView(
                                          genre: genre,
                                          onTap: (p0) {
                                            if (selectedGenres
                                                .contains(p0.genre.id)) {
                                              selectedGenres
                                                  .remove(p0.genre.id);
                                              updateRecommendedMovie(
                                                  selectedGenres);
                                            } else if (!selectedGenres
                                                .contains(p0.genre.id)) {
                                              selectedGenres.add(p0.genre.id);
                                              updateRecommendedMovie(
                                                  selectedGenres);
                                            }
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                            recommendedMovies != null &&
                                    recommendedMovies!.results.isNotEmpty
                                ? Container(
                                    color: Colors.white,
                                    height: size.height / 4,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: ((context, index) =>
                                          SizedBox(
                                              width: 150,
                                              height: 200,
                                              child: TopRatedMovieView(
                                                  movie: recommendedMovies!
                                                      .results[index]))),
                                      itemCount:
                                          recommendedMovies?.results.length,
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(AppLocalizations.of(context)!
                                        .recommended_movie_empty),
                                  ),
                          ]),
                    ),
                  const SizedBox(
                    height: 60,
                  )
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

  void updatePopularMovie() async {
    try {
      popularMovies = await ApiService().getPopularMovie();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void updateUpcomingMovie() async {
    try {
      upcomingMovies = await ApiService().getUpcomingMovie();
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

  void updateRecommendedMovie(List<int> genreIds, {int page = 1}) async {
    try {
      recommendedMovies =
          await ApiService().getFilteredMovie(genreIds, page: page);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
