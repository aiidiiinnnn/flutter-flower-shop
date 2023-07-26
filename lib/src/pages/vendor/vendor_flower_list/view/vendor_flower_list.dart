import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:get/utils.dart';
import '../controller/vendor_flower_list_controller.dart';

class VendorFlowerList extends  GetView<VendorFlowerListController>{
  const VendorFlowerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffc4c4c4),

          body: Obx(() => controller.screens[controller.index.value]),

          bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.index.value,
            onTap: (index)=>controller.onDestinationSelected(index),
            items: [
              BottomNavigationBarItem(
                  backgroundColor: const Color(0xffc4c4c4),
                  icon: const Icon(Icons.home),
                  label: locale.LocaleKeys.bottom_navigation_bar_Home.tr
              ),
              BottomNavigationBarItem(
                  backgroundColor: const Color(0xffc4c4c4),
                  icon: const Icon(Icons.history),
                  label: locale.LocaleKeys.bottom_navigation_bar_History.tr
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