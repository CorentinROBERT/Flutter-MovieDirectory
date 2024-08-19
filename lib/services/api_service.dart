import 'dart:convert';

import 'package:http/http.dart';
import 'package:movie_directory/models/response_details_movie.dart';
import 'package:movie_directory/models/response_details_movie_credit.dart';
import 'package:movie_directory/models/response_list_genre.dart';
import 'package:movie_directory/models/response_list_movie.dart';
import 'package:movie_directory/models/response_video_movie.dart';
import 'package:movie_directory/services/api_key_service.dart';

class ApiService {
  String baseUrl = "https://api.themoviedb.org/3/movie/";
  String genreUrl = "https://api.themoviedb.org/3/genre/movie/list";
  String discoverUrl = "https://api.themoviedb.org/3/discover/movie";
  String imageUrl = "https://image.tmdb.org/t/p/w500/";
  String appId = "api_key=";
  String includeAdult = "include_adult=";
  String language = "language=";
  String youtubeUrl = "https://www.youtube.com/watch?v=";

  String prepareQuery() {
    return baseUrl;
  }

  String getImage() {
    return "$imageUrl?$appId$api";
  }

  Future<ResponseListMovie?> getMovieTopRated() async {
    try {
      const isIncludeAdult = false;
      const String selectedlangage = "fr-FR";
      final queryString =
          "${prepareQuery()}top_rated?$appId$api&$language$selectedlangage&$includeAdult$isIncludeAdult";
      print(queryString);
      final call = await get(Uri.parse(queryString));
      Map<String, dynamic> map = json.decode(call.body);
      return ResponseListMovie.fromJson(map);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseListGenre?> getGenres() async {
    try {
      const String selectedlangage = "fr-FR";
      final queryString = "$genreUrl?$appId$api&$language$selectedlangage";
      print(queryString);
      final call = await get(Uri.parse(queryString));
      Map<String, dynamic> map = json.decode(call.body);
      return ResponseListGenre.fromJson(map);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseDetailsMovie?> getDetailsMovie(int movieId) async {
    try {
      const String selectedlangage = "fr-FR";
      final queryString =
          "$baseUrl$movieId?$appId$api&$language$selectedlangage";
      print(queryString);
      final call = await get(Uri.parse(queryString));
      Map<String, dynamic> map = json.decode(call.body);
      return ResponseDetailsMovie.fromJson(map);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseDetailsMovieCredit?> getDetailsMovieCredit(int movieId) async {
    try {
      const String selectedlangage = "fr-FR";
      final queryString =
          "$baseUrl$movieId/credits?$appId$api&$language$selectedlangage";
      print(queryString);
      final call = await get(Uri.parse(queryString));
      Map<String, dynamic> map = json.decode(call.body);
      return ResponseDetailsMovieCredit.fromJson(map);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseVideoMovie?> getVideoMovie(int movieId) async {
    try {
      const String selectedlangage = "fr-FR";
      final queryString =
          "$baseUrl$movieId/videos?$appId$api&$language$selectedlangage";
      print(queryString);
      final call = await get(Uri.parse(queryString));
      Map<String, dynamic> map = json.decode(call.body);
      return ResponseVideoMovie.fromJson(map);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseListMovie?> getPopularMovie() async {
    try {
      const isIncludeAdult = false;
      const String selectedlangage = "fr-FR";
      final queryString =
          "${prepareQuery()}popular?$appId$api&$language$selectedlangage&$includeAdult$isIncludeAdult";
      print(queryString);
      final call = await get(Uri.parse(queryString));
      Map<String, dynamic> map = json.decode(call.body);
      return ResponseListMovie.fromJson(map);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseListMovie?> getUpcomingMovie() async {
    try {
      const isIncludeAdult = false;
      const String selectedlangage = "fr-FR";
      final queryString =
          "${prepareQuery()}upcoming?$appId$api&$language$selectedlangage&$includeAdult$isIncludeAdult";
      print(queryString);
      final call = await get(Uri.parse(queryString));
      Map<String, dynamic> map = json.decode(call.body);
      return ResponseListMovie.fromJson(map);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseListMovie?> getFilteredMovie(List<int> genreIds,
      {int page = 1}) async {
    try {
      const isIncludeAdult = false;
      const String selectedlangage = "fr-FR";
      const String selectedPage = "page=";
      const String selectedGenre = "with_genres=";
      final queryString =
          "$discoverUrl?$appId$api&$language$selectedlangage&$includeAdult$isIncludeAdult&$selectedPage$page&$selectedGenre${genreIds.join(',')}";
      print(queryString);
      final call = await get(Uri.parse(queryString));
      Map<String, dynamic> map = json.decode(call.body);
      return ResponseListMovie.fromJson(map);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
