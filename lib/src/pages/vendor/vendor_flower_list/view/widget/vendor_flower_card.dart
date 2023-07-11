import 'dart:convert';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/controller/vendor_flower_list_controller.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
class VendorFlowerCard extends GetView<VendorFlowerListController> {
  VendorFlowerCard(
      {super.key, required this.vendorFlower, required this.index});

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
    return InkWell(
      onTap: ()=> flowerShowDialog(context),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            color: const Color(0xff2a3945),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
                height: 63,
                width: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  // borderRadius: BorderRadius.circular(10)
                ),
                child: vendorFlower.imageAddress.isNotEmpty
                    ? ClipRRect(
                    child: SizedBox.fromSize(
                        child: Image.memory(
                          base64Decode(vendorFlower.imageAddress),
                          fit: BoxFit.fill,
                        )))
                    : const Icon(Icons.image_outlined, size: 30)),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: secondHalfText.isEmpty
                      ? Center(
                    child: Text(
                      firstHalfText,
                      style: const TextStyle(fontSize: 11),
                    ),
                  )
                      : Column(
                    children: [
                      Text(
                        controller.textFlag.value
                            ? ("$firstHalfText...")
                            : (firstHalfText + secondHalfText),
                        style: const TextStyle(fontSize: 11),
                      ),
                      InkWell(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "show more",
                              style:
                              TextStyle(color: Colors.blue, fontSize: 11),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: SizedBox(
                height: 15,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: vendorFlower.color.length,
                    itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: Color(vendorFlower.color[index]),
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(200),
                          ),
                        ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: SizedBox(
                height: 25,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: vendorFlower.category.length,
                    itemBuilder: (_, index) => Transform(
                      transform: Matrix4.identity()..scale(0.7),
                      child: Chip(
                        label:
                        Center(child: Text(vendorFlower.category[index])),
                      ),
                    )),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    decrementButton(context),
                    Text(
                      "${vendorFlower.count}",
                      style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    incrementButton()
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> flowerShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xff2a3945),
        content: Container(
          width: 400,
          height: 490,
          decoration: const BoxDecoration(
              color: Color(0xff2a3945),),
          child: Column(
            children: [
              Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    // borderRadius: BorderRadius.circular(10)
                  ),
                  child: vendorFlower.imageAddress.isNotEmpty
                      ? ClipRRect(
                      child: SizedBox.fromSize(
                          child: Image.memory(
                            base64Decode(vendorFlower.imageAddress),
                            fit: BoxFit.fill,
                          )))
                      : const Icon(Icons.image_outlined, size: 30)
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      vendorFlower.name,
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.w500),
                    ),
                    Text("\$${vendorFlower.price}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(vendorFlower.description,style: const TextStyle(fontSize: 14),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                        scale: 1.3,
                        child: decrementButton(context)),
                    Text(
                      "${vendorFlower.count}",
                      style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                    ),
                    Transform.scale(
                        scale: 1.3,
                        child: incrementButton())
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        child: const Icon(Icons.delete_outline,color: Colors.white,size: 24,),
                        onTap: (){
                          Widget cancelButton = TextButton(
                              child:  const Text("Cancel"),
                              onPressed:  (){
                                Navigator.of(context).pop();
                              }
                          );
                          Widget continueButton = TextButton(
                            child:  const Text("Continue"),
                            onPressed:  () {
                              controller.deleteFlower(vendorFlower);
                              Navigator.of(context).pop();
                            },
                          );
                          AlertDialog alert = AlertDialog(
                            title:  const Text("Delete"),
                            content: const Text("Are you sure you want to delete this ?"),
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
                    SizedBox(
                      height: 25,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff71cc47),
                        ),
                        onPressed: ()=>{},
                        child: const Text('Edit'),
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
              title: Text('${vendorFlower.name} description'),
              content: SingleChildScrollView(
                child: Text(
                  firstHalfText + secondHalfText,
                  style: const TextStyle(fontSize: 12),
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
        (vendorFlower.count == 1) ? showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  const Text("Delete"),
            content: const Text("Are you sure you want to delete this ?"),
            actions: [
              TextButton(
                  child:  const Text("Cancel"),
                  onPressed:  (){
                    Navigator.of(context).pop();
                  }
              ),
              TextButton(
                child:  const Text("Continue"),
                onPressed:  () {
                  controller.deleteFlower(vendorFlower);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        ) : controller.minusFlowerCount(flowerToEdit: vendorFlower, index: index)
        });
  }
}
