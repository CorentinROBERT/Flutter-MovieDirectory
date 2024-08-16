import 'dart:convert';

import 'package:http/http.dart';
import 'package:movie_directory/models/genre.dart';
import 'package:movie_directory/models/response_details_movie.dart';
import 'package:movie_directory/models/response_details_movie_credit.dart';
import 'package:movie_directory/models/response_list_genre.dart';
import 'package:movie_directory/models/response_list_movie.dart';
import 'package:movie_directory/services/api_key_service.dart';

class ApiService {
  String baseUrl = "https://api.themoviedb.org/3/movie/";
  String genreUrl = "https://api.themoviedb.org/3/genre/movie/list";
  String imageUrl = "https://image.tmdb.org/t/p/w500/";
  String appId = "api_key=";
  String includeAdult = "include_adult=";
  String language = "language=";

  String prepareQuery() {
    return "$baseUrl";
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
}
