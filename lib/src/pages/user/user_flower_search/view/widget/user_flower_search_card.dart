import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_flower_search_controller.dart';
import '../../models/user_flower_search_view_model.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;


class UserFlowerSearchCard extends GetView<UserFlowerSearchController> {

  UserFlowerSearchCard({super.key, required this.searchFlower, required this.index});

  UserFlowerSearchViewModel searchFlower;
  int index;
  String firstHalfText = "";
  String secondHalfText = "";

  @override
  Widget build(BuildContext context) {
    if (searchFlower.description.length > 20) {
      firstHalfText = searchFlower.description.substring(0, 20);
      secondHalfText = searchFlower.description
          .substring(20, searchFlower.description.length);
    } else {
      firstHalfText = searchFlower.description;
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
                    child: searchFlower.imageAddress.isNotEmpty
                        ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox.fromSize(
                            child: Image.memory(
                              base64Decode(searchFlower.imageAddress),
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
                          searchFlower.name,
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
                    SizedBox(
                      width: 170,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("\$${searchFlower.price}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300)),
                          Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (controller.countLoading[index]=="${searchFlower.id}") ? const Center(
                                child: SizedBox(
                                    width: 50,
                                    child: LinearProgressIndicator()
                                ),
                              ) : (controller.isOutOfStock[index]) ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      child: const Icon(Icons.arrow_back_ios, size: 16),
                                      onTap: (){
                                        Widget cancelButton = TextButton(
                                            child: Text(locale.LocaleKeys.vendor_flower_card_cancel.tr),
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            }
                                        );
                                        Widget continueButton = TextButton(
                                          child: Text(locale.LocaleKeys.vendor_flower_card_continue.tr),
                                          onPressed:  () {
                                            // controller.deleteFlower(searchFlower,index);
                                            Navigator.of(context).pop();
                                          },
                                        );
                                        AlertDialog alert = AlertDialog(
                                          title: Text(locale.LocaleKeys.vendor_flower_card_delete.tr),
                                          content: Text(locale.LocaleKeys.vendor_flower_card_are_you_sure_you_want_to_delete_this.tr),
                                          actions: [
                                            cancelButton,
                                            continueButton,
                                          ],
                                        );
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                      }
                                  ),
                                  const Text(
                                    "Out of Stock",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                  ),
                                  // incrementButton()
                                ],
                              ) :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // decrementButton(context),
                                  Text(
                                    "${searchFlower.count}",
                                    style:
                                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                  ),
                                  // incrementButton()
                                ],
                              ),
                            ],
                          ),)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            right: 14,
            top: 14,
            child: Obx(() => (controller.isLoadingDelete.value=="${searchFlower.id}") ? const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator()) :
            (controller.disableLoading.value) ? const InkWell(
                onTap: null,
                child: Icon(Icons.delete_outline,color: Colors.black,size: 24)
            ) :
            InkWell(
                child: const Icon(Icons.delete_outline,color: Colors.black,size: 24),
                onTap: (){
                  Widget cancelButton = TextButton(
                      child: Text(locale.LocaleKeys.vendor_flower_card_cancel.tr),
                      onPressed: (){
                        Navigator.of(context).pop();
                      }
                  );
                  Widget continueButton = TextButton(
                    child: Text(locale.LocaleKeys.vendor_flower_card_continue.tr),
                    onPressed:  () {
                      // controller.deleteFlower(searchFlower,index);
                      Navigator.of(context).pop();
                    },
                  );
                  AlertDialog alert = AlertDialog(
                    title: Text(locale.LocaleKeys.vendor_flower_card_delete.tr),
                    content: Text(locale.LocaleKeys.vendor_flower_card_are_you_sure_you_want_to_delete_this.tr),
                    actions: [
                      cancelButton,
                      continueButton,
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                }
            ),)
          ),
        ],
      ),
    );
  }

  void _showDescription(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('${searchFlower.name} ${locale.LocaleKeys.vendor_flower_card_description.tr}'),
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

}