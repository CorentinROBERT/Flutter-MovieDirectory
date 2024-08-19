import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_directory/models/response_details_movie.dart';
import 'package:movie_directory/models/response_details_movie_credit.dart';
import 'package:movie_directory/models/response_list_movie.dart';
import 'package:movie_directory/models/response_video_movie.dart';
import 'package:movie_directory/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailsMovie extends StatefulWidget {
  Movie movie;
  ResponseDetailsMovie? detailsMovie;
  ResponseDetailsMovieCredit? credits;
  ResponseVideoMovie? videoMovie;
  DetailsMovie({super.key, required this.movie});
  VideoResult? videoResult;

  @override
  State<StatefulWidget> createState() => DetailMovieState();
}

class DetailMovieState extends State<DetailsMovie> {
  YoutubePlayerController? _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    initDetailsMovie();
    initDetailsMovieCredit();
    initVideoMovie();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
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
                            Text(AppLocalizations.of(context)!.release,
                                textAlign: TextAlign.left),
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
                                  Text(
                                    AppLocalizations.of(context)!.runtime,
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
                                      text: AppLocalizations.of(context)!.genre,
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
                            ],
                          ),
                        if (widget.credits != null)
                          Column(
                            children: [
                              SizedBox(
                                width: size.width / 2,
                                child: RichText(
                                  text: TextSpan(
                                      text: AppLocalizations.of(context)!.from,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
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
                              ),
                              if (widget.credits?.cast != null)
                                SizedBox(
                                  width: size.width / 2,
                                  child: RichText(
                                    text: TextSpan(
                                        text:
                                            AppLocalizations.of(context)!.with_,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        children: widget.credits!.cast
                                            .take(3)
                                            .map((e) => TextSpan(
                                                  text:
                                                      "${e.name} ${e.character}, ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                            .toList()),
                                  ),
                                )
                            ],
                          ),
                        if (widget.detailsMovie != null)
                          Column(
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: AppLocalizations.of(context)!.rate,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                      children: [
                                    TextSpan(
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        text:
                                            "${widget.detailsMovie?.voteAverage.toStringAsFixed(1)}/10 (${widget.detailsMovie?.voteCount})")
                                  ]))
                            ],
                          )
                      ],
                    ),
                  )
                ],
              ),
              Visibility(
                  visible: widget.detailsMovie != null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.overview,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          widget.detailsMovie != null &&
                                  widget.detailsMovie!.overview.isNotEmpty
                              ? widget.detailsMovie!.overview
                              : AppLocalizations.of(context)!
                                  .synopsis_not_available,
                          style: const TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  )),
              Visibility(
                  visible: _controller != null && widget.videoMovie != null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        _controller != null
                            ? YoutubePlayer(
                                controller: _controller!,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.amber,
                                onEnded: (metaData) {
                                  SystemChrome.setPreferredOrientations(
                                      [DeviceOrientation.portraitUp]);
                                },
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                              onPressed: () async {
                                if (!await launchUrl(
                                    Uri.parse(
                                        "${ApiService().youtubeUrl}${widget.videoResult!.key}"),
                                    mode: LaunchMode.inAppBrowserView)) {
                                  throw Exception(
                                      'Could not launch url ${ApiService().youtubeUrl}${widget.videoResult?.key ?? ""}');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  backgroundColor: Colors.lightBlue),
                              child: Text(
                                style: const TextStyle(color: Colors.white),
                                AppLocalizations.of(context)!.open_in_browser,
                              )),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
      setState(() {
        _playerState = _controller!.value.playerState;
        _videoMetaData = _controller!.metadata;
      });
    }
  }

  void initDetailsMovie() async {
    widget.detailsMovie = await ApiService().getDetailsMovie(widget.movie.id);
    setState(() {});
  }

  void initDetailsMovieCredit() async {
    widget.credits = await ApiService().getDetailsMovieCredit(widget.movie.id);
    setState(() {});
  }

  void initVideoMovie() async {
    widget.videoMovie = await ApiService().getVideoMovie(widget.movie.id);
    try {
      widget.videoResult = widget.videoMovie?.results?.firstWhere(
        (e) => e.site == "YouTube",
      );
    } catch (e) {
      widget.videoResult = null;
    }

    if (widget.videoResult != null) {
      var uri =
          Uri.parse("${ApiService().youtubeUrl}${widget.videoResult!.key}");
      print(uri);
      _controller = YoutubePlayerController(
        initialVideoId: widget.videoResult!.key!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    } else {
      // Handle missing video
      print("No YouTube video available.");
    }
    setState(() {});
  }
}
