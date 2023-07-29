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
    if (searchFlower.description.length > 25) {
      firstHalfText = searchFlower.description.substring(0, 25);
      secondHalfText = searchFlower.description
          .substring(25, searchFlower.description.length);
    } else {
      firstHalfText = searchFlower.description;
      secondHalfText = "";
    }
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        onTap:()=> flowerShowDialog(context),
        child: Container(
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
                        Obx(() => controller.isAdded[searchFlower.id]! ? (controller.addToCartLoading[index]) ? const SizedBox(
                            width: 70,
                            height: 10,
                            child: LinearProgressIndicator()
                        ) :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            controller.buyCounting[searchFlower.id]==1 ? deleteButton() : minusButton(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "${controller.buyCounting[searchFlower.id]}",
                                style:
                                const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            controller.buyCounting[searchFlower.id]==controller.maxCount[index]? disableAddButton() : addButton()
                          ],
                        ) :
                            InkWell(
                              onTap: () {
                                controller.buyCounting[searchFlower.id]=1;
                                addToCartDialog(context);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
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
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Center(child: Icon(Icons.add,size: 20)),
                              )
                            )
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
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
                Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: searchFlower.imageAddress.isNotEmpty
                        ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox.fromSize(
                            child: Image.memory(
                              base64Decode(searchFlower.imageAddress),
                              fit: BoxFit.fill,
                            )))
                        : const Icon(Icons.image_outlined, size: 30)
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        searchFlower.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      Text("\$${searchFlower.price}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400))
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: Center(
                    child: Text(searchFlower.description,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: searchFlower.color.length,
                        itemBuilder: (_, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 3.0),
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                color: Color(searchFlower.color[index]),
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(200),
                              ),
                            ))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: SizedBox(
                    height: 25,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: searchFlower.category.length,
                        itemBuilder: (_, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Chip(
                            label:
                            Center(child: Center(child: Text(searchFlower.category[index]))),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${locale.LocaleKeys.vendor_flower_card_count_in_stock.tr} ${searchFlower.count}",
                          style:
                          const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                      ],
                    ),
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

  Future<dynamic> addToCartDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xffe9e9e9),
        content: (searchFlower.count==0) ? Text(
          locale.LocaleKeys.shopping_cart_out_of_stock.tr,
          style:
          const TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
        ) : Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                (controller.buyCounting[searchFlower.id] == 0) ? _disableButton() : decrementButton(),
              ],
            ),
            Obx(() => Text(
              "${controller.buyCounting[searchFlower.id]}",
              style:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
            )),
            Row(
              children: [
                (controller.buyCounting[searchFlower.id] == (searchFlower.count)) ? _disableButton() : incrementButton(),
              ],
            )
          ],
        )),
        actions: [
          searchFlower.count==0 ?
        ElevatedButton(
            onPressed : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                Text(locale.LocaleKeys.shopping_cart_add_to_cart.tr),
              ],
            )
        ) :
        Obx(() => ElevatedButton(
            child: (controller.disableLoading.value) ? const Center(
              child: SizedBox(
                  width: 50,
                  child: LinearProgressIndicator()
              ),
            ) :
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                Text(locale.LocaleKeys.shopping_cart_add_to_cart.tr),
              ],
            ),
            onPressed: () => {
              controller.addToCart(index),
              Navigator.of(context).pop(),
            },
          ),)
        ],
      ),
    );
  }

  Widget _disableButton() {
    return const IconButton(
      onPressed: null,
      icon: Icon(Icons.close,color: Colors.black,),
    );
  }

  Widget incrementButton() {
    return IconButton(
      onPressed: () => {
        controller.onTapIncrement(flower: searchFlower,index: index),
      },
      icon: const Icon(Icons.arrow_forward_ios,color: Colors.black,),
    );
  }

  Widget decrementButton() {
    return IconButton(
      onPressed: () => {
        controller.onTapDecrement(flower: searchFlower,index: index),
      },
      icon: const Icon(Icons.arrow_back_ios,color: Colors.black),
    );
  }

  Widget disableAddButton(){
    return InkWell(
        onTap: null,
        child: Container(
          width: 22,
          height: 22,
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
              borderRadius: BorderRadius.circular(100)
          ),
          child: const Center(child: Icon(Icons.add,size: 17)),
        ),
    );
  }

  Widget addButton() {
    return InkWell(
        child: Container(
          width: 22,
          height: 22,
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
              borderRadius: BorderRadius.circular(100)
          ),
          child: const Center(child: Icon(Icons.add,size: 17)),
        ),
        onTap: () => {
          controller.onTapAdd(flower: searchFlower,index: index)
        });
  }

  Widget minusButton() {
    return InkWell(
        child: Container(
          width: 22,
          height: 22,
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
              borderRadius: BorderRadius.circular(100)
          ),
          child: const Center(child: Icon(Icons.remove,size: 17)),
        ),
        onTap: () => {
          controller.onTapMinus(flower: searchFlower,index: index)
        });
  }

  Widget deleteButton() {
    return InkWell(
        child: Container(
          width: 22,
          height: 22,
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
              borderRadius: BorderRadius.circular(100)
          ),
          child: const Center(child: Icon(Icons.close,size: 17)),
        ),
        onTap: () => {
          controller.onTapDelete(flower: searchFlower,index: index)
        });
  }

}