import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_flower_list_controller.dart';
import '../../models/user_flower_view_model.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

class UserFlowerCard extends GetView<UserFlowerListController>{

  UserFlowerCard({super.key, required this.userFlower, required this.index});
  UserFlowerViewModel userFlower;
  int index;
  String firstHalfText = "";
  String secondHalfText = "";

  @override
  Widget build(BuildContext context) {
    if (userFlower.description.length > 60) {
      firstHalfText = userFlower.description.substring(0, 60);
      secondHalfText = userFlower.description
          .substring(60, userFlower.description.length);
    } else {
      firstHalfText = userFlower.description;
      secondHalfText = "";
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 530,
        decoration: BoxDecoration(
            color: const Color(0xffe9e9e9),
            border: const Border(
              top: BorderSide(color: Color(0xff9d9d9d),width: 0.5),
              left: BorderSide(color: Color(0xff9d9d9d),width: 0.5),
              bottom: BorderSide(color: Color(0xff9d9d9d),width: 3.5),
              right: BorderSide(color: Color(0xff9d9d9d),width: 3.5),
            ),
            borderRadius: BorderRadius.circular(45)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 340,
                  width: 340,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(35)
                  ),
                  child: userFlower.imageAddress.isNotEmpty
                      ? ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: SizedBox.fromSize(
                          child: Image.memory(
                            base64Decode(userFlower.imageAddress),
                            fit: BoxFit.fill,
                          )))
                      : const Icon(Icons.image_outlined, size: 30)
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0 ,vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    userFlower.name,
                    style: const TextStyle(
                        fontSize: 29, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: secondHalfText.isEmpty
                    ? Center(
                  child: Text(
                    firstHalfText,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
                    : Column(
                  children: [
                    Text(
                      controller.textFlag.value
                          ? ("$firstHalfText...")
                          : (firstHalfText + secondHalfText),
                      style: const TextStyle(fontSize: 12),
                    ),
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            locale.LocaleKeys.vendor_flower_card_show_more.tr,
                            style:
                            const TextStyle(color: Colors.blue, fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () {
                        _showDescription(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\$${userFlower.price}",
                      style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w600)
                  ),
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff71cc47),
                      ),
                      onPressed: ()=>{
                      showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: const Color(0xffe9e9e9),
                        content: (userFlower.count==0) ? Text(
                          locale.LocaleKeys.shopping_cart_out_of_stock.tr,
                          style:
                          const TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                        ) : Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                (controller.buyCounting[index] == 0) ? _disableButton() : decrementButton(),
                              ],
                            ),
                            Obx(() => Text(
                              "${controller.buyCounting[index]}",
                              style:
                              const TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                            )),
                            Row(
                              children: [
                                (controller.buyCounting[index] == (userFlower.count)) ? _disableButton() : incrementButton(),
                              ],
                            )
                          ],
                        )),
                        actions: [
                          Obx(() => ElevatedButton(
                            child: (controller.isLoadingAddToCart.value) ? const Center(
                              child: SizedBox(
                                  width: 50,
                                  child: LinearProgressIndicator()
                              ),
                            ) :
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(Icons.shopping_cart_outlined),
                                Text(locale.LocaleKeys.shopping_cart_add_to_cart.tr),
                              ],
                            ),
                            onPressed: () => {
                              controller.addToCart(index),
                              Navigator.of(context).pop(),
                            },
                          ),)
                        ],
                      ),
                      ),

                      },
                      child: const Center(child: Icon(Icons.add,size: 17)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDescription(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('${userFlower.name} ${locale.LocaleKeys.vendor_flower_card_description.tr}'),
          content: SingleChildScrollView(
            child: Text(
              firstHalfText + secondHalfText,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text(locale.LocaleKeys.vendor_flower_card_show_less.tr),
              onPressed: () {
                controller.textFlag.value = !controller.textFlag.value;
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

  Widget _disableButton() {
    return const IconButton(
      onPressed: null,
      icon: Icon(Icons.close,color: Colors.black,),
    );
  }

  Widget incrementButton() {
    return IconButton(
      onPressed: () => {
        controller.onTapIncrement(user: userFlower,index: index),
      },
      icon: const Icon(Icons.arrow_forward_ios,color: Colors.black,),
    );
  }

  Widget decrementButton() {
    return IconButton(
      onPressed: () => {
        controller.onTapDecrement(user: userFlower,index: index),
      },
      icon: const Icon(Icons.arrow_back_ios,color: Colors.black),
    );
  }

}