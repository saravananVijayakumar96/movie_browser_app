import 'dart:io';
import 'package:movie_browser_app/utils/exports.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
    queryParameters: {
      'api_key': dotenv.env['TMDB_API_KEY'],
    },
  ));

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException err, handler) {
          String errorMsg = 'Something went wrong';

          if (err.error is SocketException) {
            errorMsg = 'No internet connection';
          } else if (err.response != null) {
            switch (err.response?.statusCode) {
              case 500:
                errorMsg = 'Internal Server Error';
                break;
              default:
                errorMsg = 'Error: ${err.response?.statusCode}';
            }
          }

          return handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: errorMsg,
              type: err.type,
              response: err.response,
            ),
          );
        },
      ),
    );
  }

  Future<List<PopularMovieResult>> fetchPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(popularMovieEndpoint, queryParameters: {
        'page': page,
      });

      List results = response.data['results'];
      return results.map((e) => PopularMovieResult.fromJson(e)).toList();
    } on DioException catch (e) {
      throw e.error ?? 'Failed to fetch movies';
    } catch (_) {
      throw 'Something went wrong';
    }
  }
}
