import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../user_flower_cart/models/cart_flower_view_model.dart';
import '../../controller/user_flower_history_controller.dart';

class UserFlowerHistoryCard extends GetView<UserFlowerHistoryController> {
  UserFlowerHistoryCard(
      {super.key, required this.historyCart, required this.index});
  final CartFlowerViewModel historyCart;
  final int index;
  String firstHalfText = "";
  String secondHalfText = "";

  @override
  Widget build(BuildContext context) {
    if (historyCart.description.length > 27) {
      firstHalfText = historyCart.description.substring(0, 27);
      secondHalfText =
          historyCart.description.substring(27, historyCart.description.length);
    } else {
      firstHalfText = historyCart.description;
      secondHalfText = "";
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color(0xffe9e9e9),
            border: Border.all(color: const Color(0xff9d9d9d)),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            historyCardImage(),
            Flexible(
              flex: 4,
              child: Column(
                children: [
                  historyCardName(),
                  historyCardVendorName(),
                  historyCardDescription()
                ],
              ),
            ),
            itemCount()
          ],
        ),
      ),
    );
  }

  Padding historyCardDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Container(
            child: secondHalfText.isEmpty
                ? Center(
                    child: Text(
                      firstHalfText,
                      style: const TextStyle(fontSize: 13),
                    ),
                  )
                : Column(
                    children: [
                      Text(
                        controller.textFlag.value
                            ? ("$firstHalfText...")
                            : (firstHalfText + secondHalfText),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  Padding historyCardImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: historyCart.imageAddress.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox.fromSize(
                    child: Image.memory(
                  base64Decode(historyCart.imageAddress),
                  fit: BoxFit.fill,
                )))
            : const Icon(Icons.image_outlined, size: 30),
      ),
    );
  }

  Flexible itemCount() {
    return Flexible(
      flex: 1,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              Text(
                "${historyCart.count}",
                style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff71cc47),
                    fontWeight: FontWeight.w500),
              ),
              (historyCart.count == 1)
                  ? const Text(
                      "Item",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff71cc47),
                          fontWeight: FontWeight.w500),
                    )
                  : const Text(
                      "Items",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff71cc47),
                          fontWeight: FontWeight.w500),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Padding historyCardVendorName() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "from: ${historyCart.vendorName} ${historyCart.vendorLastName}",
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Padding historyCardName() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            historyCart.name,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
