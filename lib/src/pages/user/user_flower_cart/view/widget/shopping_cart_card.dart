import 'dart:convert';

import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_flower_cart_controller.dart';
import '../../models/cart_flower_view_model.dart';

class ShoppingCartCard extends GetView<UserFlowerCartController> {
  ShoppingCartCard({super.key, required this.cartFlower, required this.index});

  final CartFlowerViewModel cartFlower;
  final int index;
  String firstHalfText = "";
  String secondHalfText = "";

  @override
  Widget build(BuildContext context) {
    if (cartFlower.description.length > 20) {
      firstHalfText = cartFlower.description.substring(0, 20);
      secondHalfText =
          cartFlower.description.substring(20, cartFlower.description.length);
    } else {
      firstHalfText = cartFlower.description;
      secondHalfText = "";
    }
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
                color: const Color(0xffe9e9e9),
                border: Border.all(color: const Color(0xff9d9d9d)),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                shoppingCardImage(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shoppingCardName(),
                    shoppingCardDescription(context),
                    SizedBox(
                      width: 170,
                      child: Obx(
                        () => (controller.countLoading[index])
                            ? const SizedBox(
                                width: 70,
                                height: 10,
                                child: LinearProgressIndicator())
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$${cartFlower.price}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300)),
                                  countButtons(),
                                ],
                              ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Obx(() => Positioned(
                right: 10,
                top: 10,
                child: (controller.isLoadingDelete.value)
                    ? const Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()),
                      )
                    : IconButton(
                        onPressed: () => controller.onTapDelete(
                            flower: cartFlower, index: index),
                        icon: const Icon(Icons.delete_outline)),
              ))
        ],
      ),
    );
  }

  Row countButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cartFlower.count == 1 ? deleteButton() : minusButton(),
        Text(
          "${cartFlower.count}",
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        cartFlower.count == cartFlower.totalCount
            ? disableAddButton()
            : addButton()
      ],
    );
  }

  SizedBox shoppingCardDescription(BuildContext context) {
    return SizedBox(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          locale.LocaleKeys.user_show_more.tr,
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
    );
  }

  Row shoppingCardName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          cartFlower.name,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Container shoppingCardImage() {
    return Container(
        height: 170,
        width: 170,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: cartFlower.imageAddress.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox.fromSize(
                    child: Image.memory(
                  base64Decode(cartFlower.imageAddress),
                  fit: BoxFit.fill,
                )))
            : const Icon(Icons.image_outlined, size: 30));
  }

  void _showDescription(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                  '${cartFlower.name} ${locale.LocaleKeys.user_description.tr}'),
              content: SingleChildScrollView(
                child: Text(
                  firstHalfText + secondHalfText,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text(locale.LocaleKeys.user_show_less.tr),
                  onPressed: () {
                    controller.textFlag.value = !controller.textFlag.value;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Widget disableAddButton() {
    return const InkWell(
      onTap: null,
      child: Icon(
        Icons.arrow_forward_ios,
        size: 17,
      ),
    );
  }

  Widget addButton() {
    return InkWell(
        child: const Icon(
          Icons.arrow_forward_ios,
          size: 17,
        ),
        onTap: () => {controller.onTapAdd(flower: cartFlower, index: index)});
  }

  Widget minusButton() {
    return InkWell(
        child: const Icon(
          Icons.arrow_back_ios,
          size: 17,
        ),
        onTap: () => {controller.onTapMinus(flower: cartFlower, index: index)});
  }

  Widget deleteButton() {
    return InkWell(
        child: const Icon(
          Icons.arrow_back_ios,
          size: 17,
        ),
        onTap: () =>
            {controller.onTapDelete(flower: cartFlower, index: index)});
  }
}
