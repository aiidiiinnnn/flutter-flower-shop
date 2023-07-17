import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../user_flower_list/models/user_flower_view_model.dart';
import '../../controller/user_flower_cart_controller.dart';
import '../../models/cart_Flower/cart_flower_view_model.dart';

class ShoppingCartCard extends GetView<UserFlowerCartController> {

  ShoppingCartCard({super.key, required this.cartFlower, required this.index});

  CartFlowerViewModel cartFlower;
  int index;
  String firstHalfText = "";
  String secondHalfText = "";

  @override
  Widget build(BuildContext context) {
    if (cartFlower.description.length > 20) {
      firstHalfText = cartFlower.description.substring(0, 20);
      secondHalfText = cartFlower.description
          .substring(20, cartFlower.description.length);
    } else {
      firstHalfText = cartFlower.description;
      secondHalfText = "";
    }
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
            color: const Color(0xffe9e9e9),
            border: Border.all(color: const Color(0xff9d9d9d)),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                height: 170,
                width: 170,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: cartFlower.imageAddress.isNotEmpty
                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox.fromSize(
                        child: Image.memory(
                          base64Decode(cartFlower.imageAddress),
                          fit: BoxFit.fill,
                        )))
                    : const Icon(Icons.image_outlined, size: 30)
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      cartFlower.name,
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                  width: 170,
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
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "show more",
                                style:
                                TextStyle(color: Colors.blue, fontSize: 12),
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
                SizedBox(
                  width: 170,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$${cartFlower.price}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          decrementButton(context),
                          Text(
                            "${cartFlower.count}",
                            style:
                            const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                          incrementButton()
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget incrementButton() {
    return InkWell(
        child: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => {});
  }

  Widget decrementButton(BuildContext context) {
    return InkWell(
        child: const Icon(Icons.arrow_back_ios, size: 16),
        onTap: () => {});
  }

  void _showDescription(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('${cartFlower.name} description'),
          content: SingleChildScrollView(
            child: Text(
              firstHalfText + secondHalfText,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Show less'),
              onPressed: () {
                controller.textFlag.value = !controller.textFlag.value;
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

}