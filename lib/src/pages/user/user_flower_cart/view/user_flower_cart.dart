import 'package:flower_shop/src/pages/user/user_flower_cart/view/widget/shopping_cart_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../controller/user_flower_cart_controller.dart';

class UserFlowerCart extends  GetView<UserFlowerCartController>{

  const UserFlowerCart({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xfff3f7f7),
          appBar: AppBar(
            backgroundColor: const Color(0xfff3f7f7),
            title: const Text("Shopping Cart",style: TextStyle(
                color: Color(0xff050a0a),
                fontWeight: FontWeight.w600,
                fontSize: 22
            ),),
            iconTheme: const IconThemeData(
              color: Color(0xff050a0a),
              weight: 2,
            ),
          ),
          // body: Obx(() => _pageContent(),),
          body: RefreshIndicator(
            onRefresh: controller.getUserById,
            child: Obx(() => _pageContent(),),
          )
        )
    );
  }

  Widget _pageContent() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    else if (controller.isRetry.value) {
      return _retryButton();
    }
    return _cartFlower();
  }

  Widget _retryButton() => Center(
    child: OutlinedButton(
        onPressed: controller.getUserById, child: const Icon(Icons.keyboard_return_outlined)),
  );

  Widget _cartFlower() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.cartFlowerList.length,
              itemBuilder: (_,index) => ShoppingCartCard(
                cartFlower: controller.cartFlowerList[index],
                index: index,
              )
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6cba00),
              ),
              onPressed: ()=>{
                controller.purchaseFlower()
              },
              child: const Text('Confirm purchase'),
            ),
          ),
        ),
      ],
    );
  }
}