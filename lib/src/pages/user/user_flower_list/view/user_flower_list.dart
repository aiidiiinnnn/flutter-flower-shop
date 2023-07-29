import 'package:flower_shop/src/pages/user/user_flower_list/view/screens/user_flower_home.dart';
import 'package:flower_shop/src/pages/user/user_flower_list/view/screens/user_flower_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../controller/user_flower_list_controller.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;


class UserFlowerList extends  GetView<UserFlowerListController>{

  const UserFlowerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xffc4c4c4),
            body: Obx(() => PageView(
              controller: controller.pageController,
              onPageChanged:(index)=> controller.onDestinationSelected(index),
              children: const [UserFlowerHome(),UserFlowerProfile()],
            ),),

            bottomNavigationBar: Obx(() => BottomNavigationBar(
              currentIndex: controller.pageIndex.value,
              onTap: (index) {
                controller.onDestinationSelected(index);
                controller.pageController!.jumpToPage(index);
              },
              items: [
                BottomNavigationBarItem(
                    backgroundColor: const Color(0xffc4c4c4),
                    icon: const Icon(Icons.home),
                    label: locale.LocaleKeys.bottom_navigation_bar_Home.tr
                ),
                BottomNavigationBarItem(
                    backgroundColor: const Color(0xffc4c4c4),
                    icon: const Icon(Icons.person),
                    label: locale.LocaleKeys.bottom_navigation_bar_Profile.tr
                ),
              ],
            ),)
        )
    );
  }

}