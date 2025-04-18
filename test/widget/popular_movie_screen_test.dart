import 'package:flutter_test/flutter_test.dart';
import 'package:movie_browser_app/utils/exports.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: '.env'); // ✅ Load your env before anything else
  });

  testWidgets('PopularMovieDetails displays movie info', (WidgetTester tester) async {
    final dummyMovie = PopularMovieResult(
      title: 'Test Movie',
      overview: 'This is a test overview.',
      releaseDate: '2024-05-01',
      voteAverage: 8.5,
      posterPath: '/test.jpg',
    );

    final mockController = PopularMovieController();
    mockController.selectedPopularMovie(dummyMovie);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<PopularMovieController>.value(
          value: mockController,
          child: Builder(builder: (context) {
            return MediaQuery(
              data: const MediaQueryData(size: Size(1080, 1920)),
              child: MaterialApp(
                home: Builder(
                  builder: (context) => const PopularMovieDetails(),
                ),
              ),
            );
          }),
        ),
      ),
    );

    // Replace CachedNetworkImage globally in tests using fallback
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Test Movie'), findsOneWidget);
    expect(find.text('This is a test overview.'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
