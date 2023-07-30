import 'dart:convert';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/controller/vendor_flower_list_controller.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

class VendorFlowerCard extends GetView<VendorFlowerListController> {
  VendorFlowerCard({super.key, required this.vendorFlower, required this.index});

  VendorFlowerViewModel vendorFlower;
  int index;
  String firstHalfText = "";
  String secondHalfText = "";

  @override
  Widget build(BuildContext context) {
    if (vendorFlower.description.length > 28) {
      firstHalfText = vendorFlower.description.substring(0, 28);
      secondHalfText = vendorFlower.description
          .substring(28, vendorFlower.description.length);
    } else {
      firstHalfText = vendorFlower.description;
      secondHalfText = "";
    }
    return Obx(() => (controller.isLoadingDelete.value=="${vendorFlower.id}") ? Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 28),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: const Color(0xffe9e9e9),
              border: Border.all(color: const Color(0xff9d9d9d)),
              borderRadius: BorderRadius.circular(20)),
          child: const Padding(
            padding: EdgeInsets.only(top: 115,left: 25,right: 25,bottom: 35),
            child: SizedBox(
                width: 5,
                height: 5,
                child: LinearProgressIndicator(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              height: 117,
              width: 165,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: vendorFlower.imageAddress.isNotEmpty
                  ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox.fromSize(
                      child: Image.memory(
                        base64Decode(vendorFlower.imageAddress),
                        fit: BoxFit.fill,
                      )))
                  : const Icon(Icons.image_outlined, size: 30)
          ),)
      ],
    ) :
    (controller.disableLoading.value) ? InkWell(
      onTap: null,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 28),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xffe9e9e9),
                border: Border.all(color: const Color(0xff9d9d9d)),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vendorFlower.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text("\$${vendorFlower.price}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: secondHalfText.isEmpty
                            ? Center(
                          child: Text(
                            firstHalfText,
                            style: const TextStyle(fontSize: 10),
                          ),
                        )
                            : Column(
                          children: [
                            Text(
                              controller.textFlag.value
                                  ? ("$firstHalfText...")
                                  : (firstHalfText + secondHalfText),
                              style: const TextStyle(fontSize: 10),
                            ),
                            InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    locale.LocaleKeys.vendor_show_more.tr,
                                    style:
                                    const TextStyle(color: Colors.blue, fontSize: 9),
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
                  ),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (controller.countLoading[index]=="${vendorFlower.id}") ? const Center(
                        child: SizedBox(
                            width: 50,
                            child: LinearProgressIndicator()
                        ),
                      ) : (controller.isOutOfStock[index]) ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const InkWell(
                              onTap: null,
                              child: Icon(Icons.arrow_back_ios, size: 16),
                          ),
                          Text(
                            locale.LocaleKeys.vendor_out_of_stock.tr,
                            style:
                            const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                          incrementButton()
                        ],
                      ) :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          decrementButton(context),
                          Text(
                            "${vendorFlower.count}",
                            style:
                            const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                          incrementButton()
                        ],
                      ),
                    ],
                  ),)
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: 117,
                width: 165,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: vendorFlower.imageAddress.isNotEmpty
                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox.fromSize(
                        child: Image.memory(
                          base64Decode(vendorFlower.imageAddress),
                          fit: BoxFit.fill,
                        )))
                    : const Icon(Icons.image_outlined, size: 30)
            ),)
        ],
      ),
    )
    : InkWell(
      onTap: ()=> flowerShowDialog(context),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 28),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xffe9e9e9),
                border: Border.all(color: const Color(0xff9d9d9d)),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vendorFlower.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text("\$${vendorFlower.price}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: secondHalfText.isEmpty
                            ? Center(
                          child: Text(
                            firstHalfText,
                            style: const TextStyle(fontSize: 10),
                          ),
                        )
                            : Column(
                          children: [
                            Text(
                              controller.textFlag.value
                                  ? ("$firstHalfText...")
                                  : (firstHalfText + secondHalfText),
                              style: const TextStyle(fontSize: 10),
                            ),
                            InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    locale.LocaleKeys.vendor_show_more.tr,
                                    style:
                                    const TextStyle(color: Colors.blue, fontSize: 9),
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
                  ),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (controller.countLoading[index]=="${vendorFlower.id}") ? const Center(
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
                                    child: Text(locale.LocaleKeys.vendor_cancel.tr),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    }
                                );
                                Widget continueButton = TextButton(
                                  child: Text(locale.LocaleKeys.vendor_continue.tr),
                                  onPressed:  () {
                                    controller.deleteFlower(vendorFlower,index);
                                    Navigator.of(context).pop();
                                  },
                                );
                                AlertDialog alert = AlertDialog(
                                  title: Text(locale.LocaleKeys.vendor_delete.tr),
                                  content: Text(locale.LocaleKeys.vendor_are_you_sure_you_want_to_delete_this.tr),
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
                          Text(
                            locale.LocaleKeys.vendor_out_of_stock.tr,
                            style:
                            const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                          incrementButton()
                        ],
                      ) :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          decrementButton(context),
                          Text(
                            "${vendorFlower.count}",
                            style:
                            const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                          incrementButton()
                        ],
                      ),
                    ],
                  ),)
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: 117,
                width: 165,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: vendorFlower.imageAddress.isNotEmpty
                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox.fromSize(
                        child: Image.memory(
                          base64Decode(vendorFlower.imageAddress),
                          fit: BoxFit.fill,
                        )))
                    : const Icon(Icons.image_outlined, size: 30)
            ),)
        ],
      ),
    ));
  }

  Future<dynamic> flowerShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xffe9e9e9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        content: Container(
          width: 400,
          height: 490,
          decoration: const BoxDecoration(
              color: Color(0xffe9e9e9)),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                      height: 210,
                      width: 210,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: vendorFlower.imageAddress.isNotEmpty
                          ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox.fromSize(
                              child: Image.memory(
                                base64Decode(vendorFlower.imageAddress),
                                fit: BoxFit.fill,
                              )))
                          : const Icon(Icons.image_outlined, size: 30)
                  ),
                  Positioned(
                    left: 6,
                    top: 6,
                    child: InkWell(
                        child: const Icon(Icons.delete_outline,color: Colors.black,size: 28),
                        onTap: (){
                          Widget cancelButton = TextButton(
                              child: Text(locale.LocaleKeys.vendor_cancel.tr),
                              onPressed: (){
                                Navigator.of(context).pop();
                              }
                          );
                          Widget continueButton = TextButton(
                            child: Text(locale.LocaleKeys.vendor_continue.tr),
                            onPressed:  () {
                              controller.deleteFlower(vendorFlower,index);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          );
                          AlertDialog alert = AlertDialog(
                            title: Text(locale.LocaleKeys.vendor_delete.tr),
                            content: Text(locale.LocaleKeys.vendor_are_you_sure_you_want_to_delete_this.tr),
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
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      vendorFlower.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Text("\$${vendorFlower.price}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(vendorFlower.description,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w300),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: SizedBox(
                  height: 23,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: vendorFlower.color.length,
                      itemBuilder: (_, index) => Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            height: 23,
                            width: 23,
                            decoration: BoxDecoration(
                              color: Color(vendorFlower.color[index]),
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(200),
                            ),
                          ))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 25,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: vendorFlower.category.length,
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Chip(
                          label:
                          Center(child: Text(vendorFlower.category[index])),
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${locale.LocaleKeys.vendor_count_in_stock.tr} ${vendorFlower.count}",
                      style:
                      const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                    SizedBox(
                      height: 25,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6cba00),
                        ),
                        onPressed: ()=> {
                          Navigator.of(context).pop(),
                          controller.goToEdit(vendorFlower),
                        },
                        child: Text(locale.LocaleKeys.vendor_edit.tr),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _showDescription(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('${vendorFlower.name} ${locale.LocaleKeys.vendor_description.tr}'),
              content: SingleChildScrollView(
                child: Text(
                  firstHalfText + secondHalfText,
                  style: const TextStyle(fontSize: 10),
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
            )
    );
  }

  Widget incrementButton() {
    return InkWell(
        child: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => {
          controller.addFlowerCount(flowerToEdit: vendorFlower, index: index)
        });
  }

  Widget decrementButton(BuildContext context) {
    return InkWell(
        child: const Icon(Icons.arrow_back_ios, size: 16),
        onTap: () => {
          controller.minusFlowerCount(flowerToEdit: vendorFlower, index: index)
        });
  }
}

