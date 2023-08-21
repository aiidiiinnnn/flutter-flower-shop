import 'dart:convert';

import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/search_vendor_flower_controller.dart';
import '../../models/search_vendor_flower_view_model.dart';

class SearchVendorFlowerCard extends GetView<SearchVendorFlowerController> {
  SearchVendorFlowerCard(
      {super.key, required this.vendorFlower, required this.index});

  SearchVendorFlowerViewModel vendorFlower;
  final int index;
  String firstHalfText = "";
  String secondHalfText = "";

  @override
  Widget build(BuildContext context) {
    if (vendorFlower.description.length > 20) {
      firstHalfText = vendorFlower.description.substring(0, 20);
      secondHalfText = vendorFlower.description
          .substring(20, vendorFlower.description.length);
    } else {
      firstHalfText = vendorFlower.description;
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
                cardPicture(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cardName(),
                    cardDescription(context),
                    cardPriceAndCounter(context)
                  ],
                )
              ],
            ),
          ),
          cardDeleteButton(context),
        ],
      ),
    );
  }

  Positioned cardDeleteButton(BuildContext context) {
    return Positioned(
        right: 14,
        top: 14,
        child: Obx(
          () => (controller.isLoadingDelete.value == "${vendorFlower.id}")
              ? const SizedBox(
                  height: 15, width: 15, child: CircularProgressIndicator())
              : (controller.disableLoading.value)
                  ? const InkWell(
                      onTap: null,
                      child: Icon(Icons.delete_outline,
                          color: Colors.black, size: 24))
                  : InkWell(
                      child: const Icon(Icons.delete_outline,
                          color: Colors.black, size: 24),
                      onTap: () {
                        Widget cancelButton = TextButton(
                            child: Text(locale.LocaleKeys.vendor_cancel.tr),
                            onPressed: () {
                              Navigator.of(context).pop();
                            });
                        Widget continueButton = TextButton(
                          child: Text(locale.LocaleKeys.vendor_continue.tr),
                          onPressed: () {
                            controller.deleteFlower(vendorFlower, index);
                            Navigator.of(context).pop();
                          },
                        );
                        AlertDialog alert = AlertDialog(
                          title: Text(locale.LocaleKeys.vendor_delete.tr),
                          content: Text(locale.LocaleKeys
                              .vendor_are_you_sure_you_want_to_delete_this.tr),
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
                      }),
        ));
  }

  SizedBox cardPriceAndCounter(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("\$${vendorFlower.price}",
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
          cardCounter(context)
        ],
      ),
    );
  }

  Obx cardCounter(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (controller.countLoading[index] == "${vendorFlower.id}")
              ? const Center(
                  child: SizedBox(width: 50, child: LinearProgressIndicator()),
                )
              : (controller.isOutOfStock[index])
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            child: const Icon(Icons.arrow_back_ios, size: 16),
                            onTap: () {
                              Widget cancelButton = TextButton(
                                  child:
                                      Text(locale.LocaleKeys.vendor_cancel.tr),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  });
                              Widget continueButton = TextButton(
                                child:
                                    Text(locale.LocaleKeys.vendor_continue.tr),
                                onPressed: () {
                                  controller.deleteFlower(vendorFlower, index);
                                  Navigator.of(context).pop();
                                },
                              );
                              AlertDialog alert = AlertDialog(
                                title: Text(locale.LocaleKeys.vendor_delete.tr),
                                content: Text(locale
                                    .LocaleKeys
                                    .vendor_are_you_sure_you_want_to_delete_this
                                    .tr),
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
                            }),
                        const Text(
                          "Out of Stock",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        incrementButton()
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        decrementButton(context),
                        Text(
                          "${vendorFlower.count}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        incrementButton()
                      ],
                    ),
        ],
      ),
    );
  }

  SizedBox cardDescription(BuildContext context) {
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
                          locale.LocaleKeys.vendor_show_more.tr,
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

  Row cardName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          vendorFlower.name,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Container cardPicture() {
    return Container(
        height: 170,
        width: 170,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: vendorFlower.imageAddress.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox.fromSize(
                    child: Image.memory(
                  base64Decode(vendorFlower.imageAddress),
                  fit: BoxFit.fill,
                )))
            : const Icon(Icons.image_outlined, size: 30));
  }

  Widget incrementButton() {
    return InkWell(
        child: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => {
              controller.addFlowerCount(
                  flowerToEdit: vendorFlower, index: index)
            });
  }

  Widget decrementButton(BuildContext context) {
    return InkWell(
        child: const Icon(Icons.arrow_back_ios, size: 16),
        onTap: () => {
              controller.minusFlowerCount(
                  flowerToEdit: vendorFlower, index: index)
            });
  }

  void _showDescription(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                  '${vendorFlower.name} ${locale.LocaleKeys.vendor_description.tr}'),
              content: SingleChildScrollView(
                child: Text(
                  firstHalfText + secondHalfText,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text(locale.LocaleKeys.vendor_show_less.tr),
                  onPressed: () {
                    controller.textFlag.value = !controller.textFlag.value;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
