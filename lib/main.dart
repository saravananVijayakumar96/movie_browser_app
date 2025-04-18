import 'package:movie_browser_app/utils/exports.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PopularMovieController()),
    // You can add more providers here
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PopularMovieList(),
    );
  }
}
