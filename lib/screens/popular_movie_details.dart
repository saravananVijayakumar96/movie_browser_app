import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_browser_app/controllers/popular_movie.dart';
import 'package:provider/provider.dart';

class PopularMovieDetails extends StatefulWidget {
  const PopularMovieDetails({super.key});

  @override
  State<PopularMovieDetails> createState() => _PopularMovieDetailsState();
}

class _PopularMovieDetailsState extends State<PopularMovieDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movieController = Provider.of<PopularMovieController>(context);
    final movie = movieController.selectedMovie;
    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            Center(
              child: CachedNetworkImage(
                imageUrl: '${dotenv.env['IMAGE_BASE_URL']}${movie!.posterPath}',
                height: MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.cover,
                placeholder: (_, __) => const CircularProgressIndicator(),
                errorWidget: (_, __, ___) => const Icon(
                  Icons.image,
                  size: 80,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              movie.title ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Release Date
            Text(
              'Release Date: ${movieController.formatDate(movie.releaseDate ?? '')}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${movie.voteAverage}/10',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Overview
            const Text(
              "Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              movie.overview ?? '',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
