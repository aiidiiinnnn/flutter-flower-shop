import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../user/user_flower_cart/models/cart_flower_view_model.dart';
import '../../controller/history_vendor_flower_controller.dart';

class HistoryVendorFlowerCard extends GetView<HistoryVendorFlowerController> {
  HistoryVendorFlowerCard(
      {super.key, required this.historyCart, required this.index});
  CartFlowerViewModel historyCart;
  int index;
  String firstHalfText = "";
  String secondHalfText = "";

  @override
  Widget build(BuildContext context) {
    if (historyCart.description.length > 25) {
      firstHalfText = historyCart.description.substring(0, 25);
      secondHalfText =
          historyCart.description.substring(25, historyCart.description.length);
    } else {
      firstHalfText = historyCart.description;
      secondHalfText = "";
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 12, right: 8),
      // padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 12),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 10, right: 5),
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xffe9e9e9),
                border: Border.all(color: const Color(0xff9d9d9d)),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
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
                ),
                Flexible(
                  flex: 4,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4, right: 4, top: 8, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              historyCart.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 4, right: 4, bottom: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Purchased by: ${controller.salesList[index]["userName"]} ${controller.salesList[index]["userLastName"]}",
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
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
                                              : (firstHalfText +
                                                  secondHalfText),
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          Text(
                            "${historyCart.count}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          (historyCart.count == 1)
                              ? const Text(
                                  "Item",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff71cc47)),
                                )
                              : const Text(
                                  "Items",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 25,
                width: 120,
                decoration: BoxDecoration(
                    color: const Color(0xff71cc47),
                    border: Border.all(color: const Color(0xff9d9d9d)),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "${controller.salesList[index]["date"]}",
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xffe9e9e9)),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
