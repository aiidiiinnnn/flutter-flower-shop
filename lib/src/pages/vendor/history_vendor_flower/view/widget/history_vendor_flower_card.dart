import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../user/user_flower_cart/models/cart_flower_view_model.dart';
import '../../controller/history_vendor_flower_controller.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

class HistoryVendorFlowerCard extends GetView<HistoryVendorFlowerController> {

  HistoryVendorFlowerCard({super.key,required this.historyCart,required this.index});
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
      padding: const EdgeInsets.only(top: 20,bottom: 10,left: 12,right: 8),
      // padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 12),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 10,right: 5),
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
                (historyCart.count==1) ? SizedBox(
                  height: 70,
                  width: 70,
                  child: Text("${historyCart.count} ${locale.LocaleKeys.vendor_item.tr}",style: const TextStyle(
                    fontSize: 18,
                    // color: Color(0xff71cc47)
                  ),),
                ) : SizedBox(
                  height: 70,
                  width: 70,
                  child: Text("${historyCart.count} ${locale.LocaleKeys.vendor_items.tr}",style: const TextStyle(
                    fontSize: 18,
                    // color: Color(0xff71cc47)
                  ),
                )),
              ],
            ),
          ),
          Align(
            alignment:  Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 25,
                width: 120,
                decoration: BoxDecoration(
                    color: const Color(0xff71cc47),
                    border: Border.all(color: const Color(0xff9d9d9d)),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text("${controller.salesList[index]["date"]}",style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xffe9e9e9)

                  ),),
                ),
              ),
            ),)
        ],
      ),
    );
  }
}
