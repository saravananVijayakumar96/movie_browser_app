import 'package:movie_browser_app/utils/exports.dart';

class PopularMovieList extends StatefulWidget {
  const PopularMovieList({super.key});

  @override
  State<PopularMovieList> createState() => _PopularMovieListState();
}

class _PopularMovieListState extends State<PopularMovieList> {
  final ScrollController _scrollController = ScrollController();
  late PopularMovieController movieController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      movieController =
          Provider.of<PopularMovieController>(context, listen: false);
      movieController.fetchMovies();
      _scrollController.addListener(_onScroll);
    });
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
      body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Consumer<PopularMovieController>(
            builder: (context, controller, _) {
              if (controller.error != null && controller.movies.isEmpty) {
                return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4),
                      Center(
                          child: Text(
                        controller.error!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ))
                    ]);
              }

              return GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount:
                    controller.movies.length + (controller.hasMore ? 10 : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.movies.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return popularMovieCard(controller.movies[index]);
                },
              );
            },
          )),
    );
  }

  Widget popularMovieCard(movie) {
    return InkWell(
        onTap: () {
          if (movie != null) {
            movieController.selectedPopularMovie(movie);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PopularMovieDetails()),
            );
          }
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster Image
              Expanded(
                flex: 7,
                child: CachedNetworkImage(
                  imageUrl:
                      '${dotenv.env['IMAGE_BASE_URL']}${movie.posterPath}',
                  width: double.infinity,
                  fit: BoxFit.fill,
                  placeholder: (_, __) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) => const Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.black,
                  ),
                  cacheKey: '${movie.posterPath}',
                ),
              ),
              // Title & Release Date
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
                        movieController.formatDate(movie.releaseDate),
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
        ));
  }
}
