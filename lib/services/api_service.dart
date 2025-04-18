import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_browser_app/models/popular_movie.dart';
import '../utils/constants.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
    queryParameters: {
      'api_key': dotenv.env['TMDB_API_KEY'],
    },
  ));

  Future<List<PopularMovieResult>> fetchPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(popularMovieEndpoint, queryParameters: {
        'page': page,
      });

      List results = response.data['results'];
      return results.map((e) => PopularMovieResult.fromJson(e)).toList();
    } catch (e) {
      throw 'Failed to fetch movies';
    }
  }
}
