import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies_app/api/api.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/controllers/actors_controller.dart';
import 'package:movies_app/screens/movie_details_screen.dart';

import 'package:movies_app/models/actor_movies.dart';
import 'package:movies_app/models/actor_biography.dart';
import 'package:movies_app/models/actor.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    Key? key,
    required this.actor,
  }) : super(key: key);
  
  final Actor actor;
  @override
  Widget build(BuildContext context) {
    ApiService.getMovieReviews(actor.id);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 34),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Back to home',
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Detail',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                    Tooltip(
                      message: 'Save this actor to your watch list',
                      triggerMode: TooltipTriggerMode.tap,
                      child: IconButton(
                        onPressed: () {
                          Get.find<ActorsController>().addToWatchList(actor);
                        },
                        icon: Obx(
                          () =>
                              Get.find<ActorsController>().isInWatchList(actor)
                                  ? const Icon(
                                      Icons.bookmark,
                                      color: Colors.white,
                                      size: 33,
                                    )
                                  : const Icon(
                                      Icons.bookmark_outline,
                                      color: Colors.white,
                                      size: 33,
                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 330,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        Api.imageBaseUrl + actor.profilePath,
                        width: Get.width,
                        height: 250,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, __, ___) {
                          if (___ == null) return __;
                          return FadeShimmer(
                            width: Get.width,
                            height: 250,
                            highlightColor: const Color.fromARGB(255, 0, 0, 0),
                            baseColor: const Color.fromARGB(255, 0, 0, 0),
                          );
                        },
                        errorBuilder: (_, __, ___) => const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.broken_image,
                            size: 250,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500/${actor.profilePath}',
                            width: 110,
                            height: 140,
                            fit: BoxFit.cover,
                            loadingBuilder: (_, __, ___) {
                              if (___ == null) return __;
                              return const FadeShimmer(
                                width: 110,
                                height: 140,
                                highlightColor: Color.fromARGB(255, 0, 0, 0),
                                baseColor: Color.fromARGB(255, 0, 0, 0),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 255,
                      left: 155,
                      child: SizedBox(
                        width: 230,
                        child: Text(
                          actor.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      right: 30,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color.fromRGBO(37, 40, 54, 0.52),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/Star.svg'),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  actor.popularity == 0.0
                                      ? 'N/A'
                                      : actor.popularity.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFFF8700),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.work,
                                  color: Color(0xFFFF8700),
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Known for: ${actor.knownForDepartment}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFFF8700),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<ActorBiography?>(
                      future: ApiService.getActorBiography(actor.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading actor biography: ${snapshot.error}',
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          ActorBiography biography = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  biography.biography,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              "There's no biography for this actor :(",
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<List<ActorMovies>?>(
                      future: ApiService.getActorMovie(actor.name),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          List<ActorMovies> actorMovies = snapshot.data!;
                          return actorMovies.isEmpty
                              ? const Center(
                                  child:
                                      Text('No movie information available.'),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: actorMovies
                                            .map(
                                              (actorMovies) => GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                    MovieDetailsScreen(actorMovies: actorMovies),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.network(
                                                          actorMovies.getFoto(),
                                                          height: 150,
                                                          width: 100,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        actorMovies.title,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/Star.svg',
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            actorMovies.voteAverage ==
                                                                    0.0
                                                                ? 'N/A'
                                                                : actorMovies
                                                                    .voteAverage
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/calender.svg'),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            actorMovies.releaseDate
                                                                .split('-')[0],
                                                            style:
                                                                const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                        } else {
                          return const Center(
                            child: Text('No movie information available.'),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
