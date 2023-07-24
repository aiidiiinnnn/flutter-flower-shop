import 'dart:convert';

import 'package:flower_shop/src/pages/user/user_flower_list/view/widget/user_flower_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../flower_shop.dart';
import '../../controller/user_flower_list_controller.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

class UserFlowerHome extends  GetView<UserFlowerListController>{
  const UserFlowerHome({super.key});


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
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xff050a0a),
                      weight: 2,
                    ),
                    onPressed: () async{
                      await Get.toNamed("${RouteNames.userFlowerList}${RouteNames.userFlowerHome}${RouteNames.userFlowerCart}");
                       controller.getUserById();
                    },
                  ),
                  Positioned(
                      right: 3,
                      top: 3,
                      child: Container(
                      width: 17,
                      height: 17,
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue
                      ),
                      child: Center(
                        child: Obx(() => Text("${controller.countInCart}",style: const TextStyle(
                            fontSize: 12
                        ),),)
                      )
                    // child:
                  ))
                ],
              )
            ],
          ),
          drawer: Obx(() => Drawer(
            backgroundColor: const Color(0xfff3f7f7),
            child: (controller.isLoadingDrawer.value) ?
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
                            child: controller.user!.imagePath.isNotEmpty? SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.memory(base64Decode(controller.user!.imagePath),fit: BoxFit.cover,)) :
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
                          child: Text(controller.user!.firstName,style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text(controller.user!.lastName,style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),),
                        ),
                      ],
                    )
                ),
                Text(controller.user!.email,style: const TextStyle(
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
                    onTap: () => Get.updateLocale(const Locale('en','US')),
                    child: const Row(
                      children: [
                        // SizedBox(
                        //     height: 42,
                        //     width: 42,
                        //     child: Image(image: AssetImage('assets/united_kingdom.jpg',package: 'flower_package'))
                        // ),
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
                    onTap: () => Get.updateLocale(const Locale('fa','IR')),
                    child: const Row(
                      children: [
                        // SizedBox(
                        //     height: 42,
                        //     width: 42,
                        //     child: Image(image: AssetImage('assets/iran.jpg',package: 'flower_package'))
                        // ),
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

          body: Obx(() => RefreshIndicator(
            onRefresh: controller.getFlowers,
            child: _pageContent(),
          ),),

        )
    );
  }

  Widget _pageContent() {
    if (controller.isLoading.value) {
      return const Center(
        child: SizedBox(
            width: 150,
            child: LinearProgressIndicator()
        ),
      );
    } else if (controller.isRetry.value) {
      return _retryButton();
    }
    return controller.flowersList.isNotEmpty ? _userFlower() :
    Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locale.LocaleKeys.vendor_flower_home_Home.tr,style: const TextStyle(fontSize: 72),),
            Text(locale.LocaleKeys.vendor_flower_home_there_is_no_flower_here.tr, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w300))
          ],
      ),
    );
  }

  Widget _retryButton() => Center(
    child: OutlinedButton(
        onPressed: controller.getFlowers, child: const Icon(Icons.keyboard_return_outlined)),
  );

  Widget _userFlower() => Obx(() => ListView.builder(
    itemCount: controller.flowersList.length,
    itemBuilder: (_,index) => UserFlowerCard(
        userFlower: controller.flowersList[index],
        index: index
    )
  ));

}