import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../controller/user_flower_list_controller.dart';

class UserFlowerList extends  GetView<UserFlowerListController>{

  const UserFlowerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff314657),

          body: Obx(() => controller.screens[controller.index.value]),

          bottomNavigationBar: NavigationBarTheme(
              data: NavigationBarThemeData(
                  indicatorColor: Colors.blue.shade100,
                  labelTextStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
                  )
              ),
              child: Obx(() => NavigationBar(
                height: 60,
                backgroundColor: const Color(0xfff1f5fb),
                selectedIndex: controller.index.value,
                onDestinationSelected: (index)=>controller.onDestinationSelected(index),
                destinations: const [
                  NavigationDestination(
                      icon: Icon(Icons.home),
                      label: "Home"
                  ),
                  NavigationDestination(
                      icon: Icon(Icons.history),
                      label: "History"
                  ),
                  NavigationDestination(
                      icon: Icon(Icons.search),
                      label: "Search"
                  ),
                  NavigationDestination(
                      icon: Icon(Icons.person),
                      label: "Profile"
                  )
                ],
              ),)
          ),
        )
    );
  }

}