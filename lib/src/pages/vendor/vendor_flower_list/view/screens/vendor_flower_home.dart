import 'dart:convert';

import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/widget/vendor_flower_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_flower_list_controller.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

class VendorFlowerHome extends  GetView<VendorFlowerListController>{
  const VendorFlowerHome({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xfff3f7f7),
          appBar: AppBar(
            backgroundColor: const Color(0xfff3f7f7),
            title: Text(locale.LocaleKeys.vendor_flower_home_flower_list.tr,style: const TextStyle(
                color: Color(0xff050a0a),
                fontWeight: FontWeight.w600,
                fontSize: 22
            ),),
            iconTheme: const IconThemeData(
              color: Color(0xff050a0a),
              weight: 2,
            ),
          ),
          drawer: Obx(() => Drawer(
            backgroundColor: const Color(0xfff3f7f7),
            child: (controller.isLoading.value) ?
            const Center(child: CircularProgressIndicator()) : Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height:200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Color(0xff6cba00)
                      ),
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 90),
                            height:150,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: const Color(0xff7f8283)
                            ),
                            child: controller.vendor!.imagePath.isNotEmpty? SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.memory(base64Decode(controller.vendor!.imagePath),fit: BoxFit.cover,)) :
                            const Icon(Icons.person,color: Colors.white,size: 120),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text(controller.vendor!.firstName,style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text(controller.vendor!.lastName,style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),),
                        ),
                      ],
                    )
                ),
                Text(controller.vendor!.email,style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300
                ),),

                const Divider(
                  height: 20,
                  color: Color(0xff9d9d9d),
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8,top: 17),
                  child: InkWell(
                    onTap: () {
                      Get.updateLocale(const Locale('en','US'));
                      Navigator.of(context).pop();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.language_outlined),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 4),
                          child: Text("English",style: TextStyle(
                              fontSize:17,
                              color: Color(0xff050a0a)
                          ),),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8,top: 17),
                  child: InkWell(
                    onTap: () {
                      Get.updateLocale(const Locale('fa', 'IR'));
                      Navigator.of(context).pop();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.language_outlined),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 4),
                          child: Text("فارسی",style: TextStyle(
                              fontSize:17,
                              color: Color(0xff050a0a)
                          ),),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // child: Column(
            //   children: [
            //     ElevatedButton(
            //         onPressed: () {
            //           Navigator.pop(context);
            //           controller.logOut();
            //         },
            //         child: const Text("Logout")
            //     ),
            //   ],
            // ),
          ),),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff6cba00),
            onPressed: ()=> controller.goToAdd(),
            child: const Icon(Icons.add,size: 40),
          ),

          body: Obx(() => RefreshIndicator(
            onRefresh: controller.getFlowersByVendorId,
            child: (controller.vendorFlowersList.isEmpty) ? _emptyPageContent() : _pageContent(),
          ),),

        )
    );
  }

  Widget _pageContent() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    else if (controller.isRetry.value) {
      return _retryButton();
    }
    return _vendorFlower();
  }

  Widget _emptyPageContent() {
    // if (controller.isLoading.value) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    // else if (controller.isRetry.value) {
    //   return _retryButton();
    // }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(locale.LocaleKeys.vendor_flower_home_Home.tr,style: const TextStyle(fontSize: 72),),
          Text(locale.LocaleKeys.vendor_flower_home_there_is_no_flower_here.tr, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w300))
        ],
      ),
    );
  }

  // Widget _pageContent() {
  //   if (controller.isLoading.value) {
  //     return const Center(child: CircularProgressIndicator());
  //   } else if (controller.isRetry.value) {
  //     return _retryButton();
  //   }
  //   return controller.vendorFlowersList.isNotEmpty ? _vendorFlower() :
  //   Center(
  //     child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(locale.LocaleKeys.vendor_flower_home_Home.tr,style: const TextStyle(fontSize: 72),),
  //           Text(locale.LocaleKeys.vendor_flower_home_there_is_no_flower_here.tr, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w300))
  //         ],
  //     ),
  //   );
  // }

  Widget _retryButton() => Center(
    child: OutlinedButton(
        onPressed: controller.getFlowersByVendorId, child: const Icon(Icons.keyboard_return_outlined)),
  );

  Widget _vendorFlower() => Obx(() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: GridView.builder(
      itemCount: controller.vendorFlowersList.length,
      itemBuilder: (_,index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: VendorFlowerCard(
              vendorFlower: controller.vendorFlowersList[index],
              index: index
          )
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // crossAxisSpacing: 0,
      ),
    ),
  ));

}