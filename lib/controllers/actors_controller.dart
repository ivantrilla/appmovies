import 'package:get/get.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/models/actor.dart';

class ActorsController extends GetxController {
  var isLoading = false.obs;
  var mainTopRatedActors = <Actor>[].obs;
  var watchListActors = <Actor>[].obs;
  @override
  void onInit() async {
    isLoading.value = true;
    mainTopRatedActors.value = (await ApiService.getTopRatedActors())!;
    isLoading.value = false;
    super.onInit();
  }

  bool isInWatchList(Actor actor) {
    return watchListActors.any((m) => m.id == actor.id);
  }

  void addToWatchList(Actor actor) {
    if (watchListActors.any((m) => m.id == actor.id)) {
      watchListActors.remove(actor);
      Get.snackbar('Success', 'removed from favourites list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    } else {
      watchListActors.add(actor);
      Get.snackbar('Success', 'added to favourites list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    }
  }
}
