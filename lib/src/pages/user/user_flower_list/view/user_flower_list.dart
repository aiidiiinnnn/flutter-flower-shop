import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../controller/user_flower_list_controller.dart';

class UserFlowerList extends  GetView<UserFlowerListController>{

  const UserFlowerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff314657),
          appBar: AppBar(
            backgroundColor: const Color(0xffb32437),
            title: const Text("User Flower List"),
          ),
          body: const Text("Hi 2"),
        )
    );
  }

}