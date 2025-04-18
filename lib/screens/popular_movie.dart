import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_browser_app/controllers/popular_movie.dart';
import 'package:provider/provider.dart';

class PopularMovieList extends StatefulWidget {
  const PopularMovieList({super.key});

  @override
  State<PopularMovieList> createState() => _PopularMovieListState();
}

class _PopularMovieListState extends State<PopularMovieList> {
  final ScrollController _scrollController = ScrollController();
  late PopularMovieController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<PopularMovieController>(context, listen: false);
    controller.fetchMovies();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final controller =
        Provider.of<PopularMovieController>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      if (!controller.isLoading && controller.hasMore) {
        controller.fetchMovies();
      }
    }
  }

  Future<void> _onRefresh() async {
    await Provider.of<PopularMovieController>(context, listen: false)
        .fetchMovies(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          'Popular Movies',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Consumer<PopularMovieController>(
        builder: (context, controller, _) {
          if (controller.error != null && controller.movies.isEmpty) {
            return Center(child: Text(controller.error!));
          }

          return RefreshIndicator(
              onRefresh: _onRefresh,
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount:
                    controller.movies.length + (controller.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.movies.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return popularMovieCard(controller.movies[index]);
                },
              ));
        },
      ),
    );
  }

  Widget popularMovieCard(movie) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster Image
          Expanded(
            flex: 7,
            child: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              width: double.infinity,
              fit: BoxFit.fill,
              placeholder: (_, __) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
          // Title & Date
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.formatDate(movie.releaseDate),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
