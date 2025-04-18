import 'package:flutter_test/flutter_test.dart';
import 'package:movie_browser_app/utils/exports.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: '.env'); // ✅ Load your env before anything else
  });

  group('PopularMovieController Unit Tests', () {
    test('Initial values are set correctly', () {
      final controller = PopularMovieController();

      expect(controller.movies, isEmpty);
      expect(controller.selectedMovie, isNull);
      expect(controller.hasMore, isTrue);
      expect(controller.isLoading, isFalse);
      expect(controller.error, isNull);
    });

    test('Selecting a movie updates selectedMovie and notifies listeners', () {
      final controller = PopularMovieController();
      bool didNotify = false;

      controller.addListener(() {
        didNotify = true;
      });

      final movie = PopularMovieResult(
        title: 'Inception',
        posterPath: '/abc.jpg',
        releaseDate: '2010-07-16',
        voteAverage: 8.5,
        overview: 'A mind-bending thriller.',
        id: 123,
      );

      controller.selectedPopularMovie(movie);

      expect(controller.selectedMovie, movie);
      expect(didNotify, isTrue);
    });
  });
}
