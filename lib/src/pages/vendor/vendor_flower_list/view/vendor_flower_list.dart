import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/screens/vendor_flower_home.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/screens/vendor_flower_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../controller/vendor_flower_list_controller.dart';

class VendorFlowerList extends GetView<VendorFlowerListController> {
  const VendorFlowerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xfff3f7f7),
            body: Obx(
              () => PageView(
                controller: controller.pageController,
                onPageChanged: (index) =>
                    controller.onDestinationSelected(index),
                children: const [VendorFlowerHome(), VendorFlowerProfile()],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xff6cba00),
              onPressed: () => {
                controller.goToAdd(),
              },
              child: const Icon(Icons.add, size: 40),
            ),
            bottomNavigationBar: Obx(
              () => BottomAppBar(
                notchMargin: 10,
                shape: const CircularNotchedRectangle(),
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          controller.pageIndex.value = 0;
                          controller.onDestinationSelected(
                              controller.pageIndex.value);
                          controller.pageController
                              .jumpToPage(controller.pageIndex.value);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home,
                                color: controller.pageIndex.value == 0
                                    ? Colors.blue
                                    : Colors.grey),
                            Text(
                              "Home",
                              style: TextStyle(
                                  color: controller.pageIndex.value == 0
                                      ? Colors.blue
                                      : Colors.grey),
                            )
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          controller.pageIndex.value = 1;
                          controller.onDestinationSelected(
                              controller.pageIndex.value);
                          controller.pageController
                              .jumpToPage(controller.pageIndex.value);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person,
                                color: controller.pageIndex.value == 1
                                    ? Colors.blue
                                    : Colors.grey),
                            Text(
                              "Profile",
                              style: TextStyle(
                                  color: controller.pageIndex.value == 1
                                      ? Colors.blue
                                      : Colors.grey),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )

            // bottomNavigationBar: Obx(() => BottomNavigationBar(
            //   currentIndex: controller.pageIndex.value,
            //   onTap: (index) {
            //     controller.onDestinationSelected(index);
            //     controller.pageController!.jumpToPage(index);
            //   },
            //   items: [
            //     BottomNavigationBarItem(
            //         backgroundColor: const Color(0xffc4c4c4),
            //         icon: const Icon(Icons.home),
            //         label: locale.LocaleKeys.bottom_navigation_bar_Home.tr
            //     ),
            //     BottomNavigationBarItem(
            //         backgroundColor: const Color(0xffc4c4c4),
            //         icon: const Icon(Icons.person),
            //         label: locale.LocaleKeys.bottom_navigation_bar_Profile.tr
            //     ),
            //   ],
            // ),)
            ));
  }
}
