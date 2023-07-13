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
            backgroundColor: const Color(0xffc4c4c4),
            body: Obx(() => controller.screens[controller.index.value]),
            bottomNavigationBar: Obx(() => BottomNavigationBar(
              currentIndex: controller.index.value,
              onTap: (index)=>controller.onDestinationSelected(index),
              items: const [
                BottomNavigationBarItem(
                    backgroundColor: Color(0xffc4c4c4),
                    icon: Icon(Icons.home),
                    label: "Home"
                ),
                BottomNavigationBarItem(
                    backgroundColor: Color(0xffc4c4c4),
                    icon: Icon(Icons.history),
                    label: "History"
                ),
                BottomNavigationBarItem(
                    backgroundColor: Color(0xffc4c4c4),
                    icon: Icon(Icons.search),
                    label: "Search"
                ),
                BottomNavigationBarItem(
                    backgroundColor: Color(0xffc4c4c4),
                    icon: Icon(Icons.person),
                    label: "Profile"
                ),
              ],
            ),)
        )
    );
  }

}