import 'package:flower_shop/src/pages/user/user_flower_list/view/widget/user_flower_card.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/widget/vendor_flower_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../../../flower_shop.dart';
import '../../controller/user_flower_list_controller.dart';

class UserFlowerHome extends  GetView<UserFlowerListController>{
  const UserFlowerHome({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xfff3f7f7),
          appBar: AppBar(
            backgroundColor: const Color(0xfff3f7f7),
            title: const Text("User Flower List",style: TextStyle(
                color: Color(0xff050a0a),
                fontWeight: FontWeight.w600,
                fontSize: 22
            ),),
            iconTheme: const IconThemeData(
              color: Color(0xff050a0a),
              weight: 2,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xff050a0a),
                  weight: 2,
                ),
                onPressed: () {
                  Get.toNamed("${RouteNames.userFlowerList}${RouteNames.userFlowerHome}${RouteNames.userFlowerCart}");
                },
              )
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      controller.logOut();
                    },
                    child: const Text("Logout")
                ),
              ],
            ),
          ),

          body: Obx(() => RefreshIndicator(
            onRefresh: controller.getFlowers,
            child: _pageContent(),
          ),),

        )
    );
  }

  Widget _pageContent() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    } else if (controller.isRetry.value) {
      return _retryButton();
    }
    return controller.flowersList.isNotEmpty ? _userFlower() :
    const Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home',style: TextStyle(fontSize: 72),),
            Text('There is no flower to buy', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300))
          ],
      ),
    );
  }

  Widget _retryButton() => Center(
    child: OutlinedButton(
        onPressed: controller.getFlowers, child: const Icon(Icons.keyboard_return_outlined)),
  );

  Widget _userFlower() => Obx(() => ListView.builder(
    itemCount: controller.flowersList.length,
    itemBuilder: (_,index) => UserFlowerCard(
        userFlower: controller.flowersList[index],
        index: index
    )
  ));

}