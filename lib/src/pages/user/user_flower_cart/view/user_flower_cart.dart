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
            title: Text(locale.LocaleKeys.user_shopping_cart.tr,style: const TextStyle(
                color: Color(0xff050a0a),
                fontWeight: FontWeight.w600,
                fontSize: 22
            ),),
            iconTheme: const IconThemeData(
              color: Color(0xff050a0a),
              weight: 2,
            ),
          ),

          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.getUserById,
                  child: Obx(() => _pageContent(),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(locale.LocaleKeys.user_total_price.tr,style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                    ),),
                    Obx(() => Text("${controller.stringPrice.value}\$",style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    )),)
                  ],
                ),
              ),
              Obx(() => (controller.cartFlowerList.isEmpty) ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6cba00),
                      ),
                      onPressed: null,
                      child: Text(locale.LocaleKeys.user_confirm_purchase.tr)
                  ),
                ),
              ): Padding(
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
                      ) : Text(locale.LocaleKeys.user_confirm_purchase.tr),)
                  ),
                ),
              )
              ),

            ],
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
    else if(controller.cartFlowerList.isEmpty){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart,size: 270),
            Text(locale.LocaleKeys.user_no_flower_founded_to_purchase.tr, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
          ],
        ),
      );
    }
    return _cartFlower();
  }

  Widget _retryButton() => Center(
    child: OutlinedButton(
        onPressed: controller.getUserById, child: const Icon(Icons.keyboard_return_outlined)),
  );

  Widget _cartFlower() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.cartFlowerList.length,
        itemBuilder: (_,index) => ShoppingCartCard(
          cartFlower: controller.cartFlowerList[index],
          index: index,
        )
    );
  }
}