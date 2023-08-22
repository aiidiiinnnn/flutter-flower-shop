import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/screens/vendor_flower_home.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/screens/vendor_flower_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_ui/taav_ui.dart';

import '../controller/vendor_flower_list_controller.dart';

class VendorFlowerList extends GetView<VendorFlowerListController> {
  const VendorFlowerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xfff3f7f7),
            body: pageContent(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: floatingAction(),
            bottomNavigationBar: bottomNavigation()));
  }

  TaavFloatingActionButtonMenu floatingAction() {
    return TaavFloatingActionButtonMenu(
      direction: AxisDirection.up,
      backgroundColor: const Color(0xff6cba00),
      buttonCustomChild: const Center(
        child: Icon(Icons.add, size: 40)
      ),
      activeButtonCustomChild: const Center(
        child:  Icon(Icons.close, size: 35)
      ),
      useRotationAnimation: false,
      items: [
        TaavFloatingActionButtonMenuItem(
          icon: Icons.spa_outlined,
          onTap: () => controller.goToAdd(),
          backgroundColor: TaavColors.red,
        ),
        TaavFloatingActionButtonMenuItem(
          icon: Icons.search_outlined,
          onTap: () => controller.goToSearch(),
          backgroundColor: TaavColors.blue,
        ),
        TaavFloatingActionButtonMenuItem(
          icon: Icons.history_outlined,
          onTap: () => controller.goToHistory(),
        ),
      ],
    );

  }

  Obx pageContent() {
    return Obx(
      () => PageView(
        controller: controller.pageController,
        onPageChanged: (index) => controller.onDestinationSelected(index),
        children: const [VendorFlowerHome(), VendorFlowerProfile()],
      ),
    );
  }

  Obx bottomNavigation() {
    return Obx(
      () => BottomAppBar(
        notchMargin: 10,
        shape: const CircularNotchedRectangle(),
        child: bottomNavigationButtons(),
      ),
    );
  }

  SizedBox bottomNavigationButtons() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MaterialButton(
            minWidth: 40,
            onPressed: () {
              controller.pageIndex.value = 0;
              controller.onDestinationSelected(controller.pageIndex.value);
              controller.pageController.jumpToPage(controller.pageIndex.value);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home,
                    color: controller.pageIndex.value == 0
                        ? Colors.blue
                        : Colors.grey),
                Text(
                  locale.LocaleKeys.vendor_home.tr,
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
              controller.onDestinationSelected(controller.pageIndex.value);
              controller.pageController.jumpToPage(controller.pageIndex.value);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person,
                    color: controller.pageIndex.value == 1
                        ? Colors.blue
                        : Colors.grey),
                Text(
                  locale.LocaleKeys.vendor_profile.tr,
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
    );
  }
}
