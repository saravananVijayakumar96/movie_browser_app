import 'package:flutter/material.dart';
import 'package:movie_browser_app/models/popular_movie.dart';
import 'package:movie_browser_app/services/api_service.dart';
import 'package:intl/intl.dart';

class PopularMovieController with ChangeNotifier {
  final ApiService _api = ApiService();
  List<PopularMovieResult> movies = [];
  PopularMovieResult? selectedMovie;
  int _page = 1;
  bool isLoading = false;
  bool hasMore = true;
  String? error;

  Future<void> fetchMovies({bool refresh = false}) async {
    if (isLoading) return;
    isLoading = true;
    error = null;

    if (refresh) {
      _page = 1;
      movies.clear();
      hasMore = true;
    }

    notifyListeners();

    try {
      final result = await _api.fetchPopularMovies(page: _page);
      if (result.isEmpty && movies.isEmpty) {
        error = 'No popular movies found.';
        hasMore = false;
      } else {
        if (result.length < 10) hasMore = false;
        movies.addAll(result);
        _page++;
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final formatter = DateFormat('dd MMM yyyy');
      return formatter.format(date).toUpperCase();
    } catch (e) {
      return '';
    }
  }

  void selectedPopularMovie(PopularMovieResult movie) {
    selectedMovie = movie;
    notifyListeners();
  }
}
