import 'package:flower_shop/src/pages/user/user_flower_cart/view/widget/shopping_cart_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_flower_cart_controller.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

class UserFlowerCart extends  GetView<UserFlowerCartController>{

  const UserFlowerCart({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xfff3f7f7),
          appBar: AppBar(
            backgroundColor: const Color(0xfff3f7f7),
            title: Text(locale.LocaleKeys.shopping_cart_shopping_cart.tr,style: const TextStyle(
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
        Obx(() => Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(locale.LocaleKeys.shopping_cart_total_price.tr,style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20
              ),),
              Text("${controller.totalPrice.value}\$",style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
              )),
            ],
          ),
        )),
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
              child: Obx(() => (controller.isLoadingPurchase.value) ? const Center(
                child: SizedBox(
                    width: 50,
                    child: LinearProgressIndicator()
                ),
              ) : Text(locale.LocaleKeys.shopping_cart_confirm_purchase.tr),)
            ),
          ),
        ),
      ],
    );
  }
}