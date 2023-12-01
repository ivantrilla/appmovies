import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies_app/controllers/bottom_navigator_controller.dart';

class Main extends StatelessWidget {
  Main({Key? key}) : super(key: key);
  
  final BottomNavigatorController controller = Get.put(BottomNavigatorController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.index.value,
              children: Get.find<BottomNavigatorController>().screens,
            ),
          ),
          bottomNavigationBar: Container(
            height: 78,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0),
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.index.value,
              onTap: (index) =>
                  Get.find<BottomNavigatorController>().setIndex(index),
              backgroundColor: const Color.fromARGB(255, 255, 128, 0),
              selectedItemColor: const Color.fromARGB(255, 255, 0, 0),
              unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: SvgPicture.asset(
                      'assets/Home.svg',
                      height: 21,
                      width: 21,
                      color: controller.index.value == 0
                          ? const Color.fromARGB(255, 255, 0, 0)
                          : const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  label: 'Home',
                  tooltip: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: SvgPicture.asset(
                      'assets/Search.svg',
                      height: 21,
                      width: 21,
                      color: controller.index.value == 1
                          ? const Color.fromARGB(255, 255, 0, 0)
                          : const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  label: 'Search',
                  tooltip: 'Search Actors',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: SvgPicture.asset(
                      'assets/Save.svg',
                      height: 21,
                      width: 21,
                      color: controller.index.value == 2
                          ? const Color.fromARGB(255, 255, 0, 0)
                          : const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  label: 'Saved Actors',
                  tooltip: 'Your saved list',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
