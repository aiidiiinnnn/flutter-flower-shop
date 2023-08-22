import 'dart:convert';

import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_flower_list_controller.dart';
import '../../models/user_flower_view_model.dart';

class UserFlowerCard extends GetView<UserFlowerListController> {
  UserFlowerCard({super.key, required this.userFlower, required this.index});
  UserFlowerViewModel userFlower;
  int index;
  String firstHalfText = "";
  String secondHalfText = "";

  @override
  Widget build(BuildContext context) {
    if (userFlower.description.length > 52) {
      firstHalfText = userFlower.description.substring(0, 52);
      secondHalfText =
          userFlower.description.substring(52, userFlower.description.length);
    } else {
      firstHalfText = userFlower.description;
      secondHalfText = "";
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 600,
        decoration: BoxDecoration(
            color: const Color(0xffe9e9e9),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff9d9d9d).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(4, 4), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(45)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 210,
                  width: 340,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(35)),
                  child: userFlower.imageAddress.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: SizedBox.fromSize(
                              child: Image.memory(
                            base64Decode(userFlower.imageAddress),
                            fit: BoxFit.fill,
                          )))
                      : const Icon(Icons.image_outlined, size: 30)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                height: 18,
                width: 200,
                child: Center(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: userFlower.color.length,
                      itemBuilder: (_, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(userFlower.color[index]),
                            ),
                          ))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                  height: 24,
                  width: 250,
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: userFlower.category.length,
                      itemBuilder: (_, index) => Chip(
                        label: Text(
                          userFlower.category[index],
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                userFlower.name,
                style:
                    const TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "from: ${userFlower.vendorName} ${userFlower.vendorLastName}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xff7f8283)),
                    child: userFlower.vendorImage.isNotEmpty
                        ? SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.memory(
                              base64Decode(userFlower.vendorImage),
                              fit: BoxFit.cover,
                            ))
                        : const Icon(Icons.person,
                            color: Colors.white, size: 15),
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
                                ? (firstHalfText)
                                : (firstHalfText + secondHalfText),
                            style: const TextStyle(fontSize: 12),
                          ),
                          InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Text(
                                    locale.LocaleKeys.user_show_more.tr,
                                    style: const TextStyle(
                                        color: Colors.blue, fontSize: 12),
                                  ),
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
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\$${userFlower.price}",
                      style: const TextStyle(
                          fontSize: 35, fontWeight: FontWeight.w600)),
                  Obx(
                    () => controller.isAdded[userFlower.id]!
                        ? (controller.addToCartLoading[index])
                            ? const SizedBox(
                                width: 70,
                                height: 10,
                                child: LinearProgressIndicator())
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  controller.buyCounting[userFlower.id] == 1
                                      ? deleteButton()
                                      : minusButton(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(
                                      "${controller.buyCounting[userFlower.id]}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                  ),
                                  controller.buyCounting[userFlower.id] ==
                                          controller.maxCount[index]
                                      ? disableAddButton()
                                      : addButton()
                                ],
                              )
                        : SizedBox(
                            width: 45,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff71cc47),
                              ),
                              onPressed: () {
                                controller.buyCounting[userFlower.id] = 1;
                                addToCartDialog(context);
                              },
                              child: const Center(
                                  child: Icon(Icons.add, size: 17)),
                            ),
                          ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> addToCartDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xffe9e9e9),
        content: (userFlower.count == 0)
            ? Text(
                locale.LocaleKeys.user_out_of_stock.tr,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
              )
            : Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        (controller.buyCounting[userFlower.id] == 0)
                            ? _disableButton()
                            : decrementButton(),
                      ],
                    ),
                    Obx(() => Text(
                          "${controller.buyCounting[userFlower.id]}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 21),
                        )),
                    Row(
                      children: [
                        (controller.buyCounting[userFlower.id] ==
                                (userFlower.count))
                            ? _disableButton()
                            : incrementButton(),
                      ],
                    )
                  ],
                )),
        actions: [
          userFlower.count == 0
              ? ElevatedButton(
                  onPressed: null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.shopping_cart_outlined),
                      Text(locale.LocaleKeys.user_add_to_cart.tr),
                    ],
                  ))
              : Obx(
                  () => ElevatedButton(
                    child: (controller.disableLoading.value)
                        ? const Center(
                            child: SizedBox(
                                width: 50, child: LinearProgressIndicator()),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.shopping_cart_outlined),
                              Text(locale.LocaleKeys.user_add_to_cart.tr),
                            ],
                          ),
                    onPressed: () => {
                      controller.addToCart(index),
                      Navigator.of(context).pop(),
                    },
                  ),
                )
        ],
      ),
    );
  }

  Widget disableAddButton() {
    return const InkWell(
        onTap: null,
        child: Icon(
          Icons.add_circle_outlined,
          size: 28,
          color: Color(0xff71cc47),
        ));
  }

  Widget addButton() {
    return InkWell(
        child: const Icon(
          Icons.add_circle_outlined,
          size: 28,
          color: Color(0xff71cc47),
        ),
        onTap: () => {controller.onTapAdd(flower: userFlower, index: index)});
  }

  Widget minusButton() {
    return InkWell(
        child: const Icon(
          Icons.remove_circle_outlined,
          size: 28,
          color: Color(0xff71cc47),
        ),
        onTap: () => {controller.onTapMinus(flower: userFlower, index: index)});
  }

  Widget deleteButton() {
    return InkWell(
        child: const Icon(
          Icons.delete,
          size: 28,
          color: Color(0xff71cc47),
        ),
        onTap: () =>
            {controller.onTapDelete(flower: userFlower, index: index)});
  }

  void _showDescription(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                  '${userFlower.name} ${locale.LocaleKeys.user_description.tr}'),
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

  Widget _disableButton() {
    return const IconButton(
      onPressed: null,
      icon: Icon(
        Icons.close,
        color: Colors.black,
      ),
    );
  }

  Widget incrementButton() {
    return IconButton(
      onPressed: () => {
        controller.onTapIncrement(flower: userFlower, index: index),
      },
      icon: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
      ),
    );
  }

  Widget decrementButton() {
    return IconButton(
      onPressed: () => {
        controller.onTapDecrement(flower: userFlower, index: index),
      },
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
    );
  }
}
