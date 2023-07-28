import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../user/user_flower_cart/models/cart_flower_view_model.dart';
import '../../controller/vendor_flower_list_controller.dart';

class VendorFlowerHistoryCard extends GetView<VendorFlowerListController> {

  VendorFlowerHistoryCard({super.key,required this.historyCart,required this.index});
  CartFlowerViewModel historyCart;
  int index;
  String firstHalfText = "";
  String secondHalfText = "";

  @override
  Widget build(BuildContext context) {
    if (historyCart.description.length > 25) {
      firstHalfText = historyCart.description.substring(0, 25);
      secondHalfText = historyCart.description
          .substring(25, historyCart.description.length);
    } else {
      firstHalfText = historyCart.description;
      secondHalfText = "";
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color(0xffe9e9e9),
            border: Border.all(color: const Color(0xff9d9d9d)),
            borderRadius: BorderRadius.circular(20)
        ),
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
                      borderRadius: BorderRadius.circular(15)
                  ),
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
            SizedBox(
              height: 70,
              width: 190,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(historyCart.name,style: const TextStyle(
                        fontSize: 16
                      ),),
                    ],
                  ),
                  Row(
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
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 70,
              width: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${historyCart.count}",style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xff71cc47)
                  ),),
                  Text("${controller.salesList[index]["date"]}",style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff71cc47)
                  ),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
