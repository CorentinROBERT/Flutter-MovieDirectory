import 'package:flutter/material.dart';
import 'package:movie_directory/models/response_details_movie.dart';
import 'package:movie_directory/models/response_details_movie_credit.dart';
import 'package:movie_directory/models/response_list_movie.dart';
import 'package:movie_directory/services/api_service.dart';
import 'package:intl/intl.dart';

class DetailsMovie extends StatefulWidget {
  Movie movie;
  ResponseDetailsMovie? detailsMovie;
  ResponseDetailsMovieCredit? credits;
  DetailsMovie({super.key, required this.movie});

  @override
  State<StatefulWidget> createState() => DetailMovieState();
}

class DetailMovieState extends State<DetailsMovie> {
  @override
  void initState() {
    initDetailsMovie();
    initDetailsMovieCredit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: const BackButton(),
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Image.network(
                      fit: BoxFit.fill,
                      "${ApiService().imageUrl}${widget.movie.posterPath}",
                      width: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("Sortie : ", textAlign: TextAlign.left),
                            Text(
                              DateFormat("dd MMMM yyyy").format(
                                  DateTime.parse(widget.movie.releaseDate)),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        if (widget.detailsMovie != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Durée : ",
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "${widget.detailsMovie!.runtime ~/ 60}h${widget.detailsMovie!.runtime % 60}min",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: size.width / 2,
                                child: RichText(
                                  text: TextSpan(
                                      text: "Genre : ",
                                      style:
                                          const TextStyle(color: Colors.black),
                                      children: widget.detailsMovie!.genres
                                          .map((e) => TextSpan(
                                                text: "${e.name}, ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))
                                          .toList()),
                                ),
                              ),
                              if (widget.credits != null)
                                SizedBox(
                                  width: size.width / 2,
                                  child: RichText(
                                    text: TextSpan(
                                        text: "De : ",
                                        style: const TextStyle(
                                            color: Colors.black),
                                        children: widget.credits!.crew
                                            .where((e) =>
                                                e.knownForDepartment ==
                                                    "Directing" &&
                                                e.job == "Director")
                                            .map((e) => TextSpan(
                                                  text: "${e.name} ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                            .toList()),
                                  ),
                                )
                            ],
                          )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void initDetailsMovie() async {
    widget.detailsMovie = await ApiService().getDetailsMovie(widget.movie.id);
    setState(() {});
  }

  void initDetailsMovieCredit() async {
    widget.credits = await ApiService().getDetailsMovieCredit(widget.movie.id);
    setState(() {});
  }
}
