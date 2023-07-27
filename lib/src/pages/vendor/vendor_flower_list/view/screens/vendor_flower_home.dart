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
                  padding: const EdgeInsetsDirectional.only(start: 10,top: 20),
                  child: InkWell(
                    onTap: () => {
                      Navigator.of(context).pop(),
                      controller.goToSearch()
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.search_outlined),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 4),
                          child: Text("Search",style: TextStyle(
                              fontSize:17,
                              color: Color(0xff050a0a)
                          ),),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10,top: 30),
                  child: InkWell(
                    onTap: () => {
                      Navigator.of(context).pop(),
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.history_outlined),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 4),
                          child: Text("History",style: TextStyle(
                              fontSize:17,
                              color: Color(0xff050a0a)
                          ),),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10,top: 30),
                  child: InkWell(
                    onTap: () => {
                      Navigator.of(context).pop(),
                      controller.logOut(),
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.login_outlined),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 4),
                          child: Text("Logout",style: TextStyle(
                              fontSize:17,
                              color: Color(0xff050a0a)
                          ),),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10,top: 30),
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
                  padding: const EdgeInsetsDirectional.only(start: 10,top: 30),
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
          ),),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff6cba00),
            onPressed: ()=> controller.goToAdd(),
            child: const Icon(Icons.add,size: 40),
          ),

          body: Obx(() => RefreshIndicator(
            onRefresh:controller.getFlowersByVendorId,
            child: _pageContent(),
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
    else if(controller.vendorFlowersList.isEmpty){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_outlined,size: 270),
            Text(locale.LocaleKeys.vendor_flower_home_there_is_no_flower_here.tr, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
          ],
        ),
      );
    }
    return _vendorFlower();
  }

  Widget _retryButton() => Center(
    child: OutlinedButton(
        onPressed: controller.getFlowersByVendorId, child: const Icon(Icons.refresh_outlined)
    ),
  );

  Widget _vendorFlower() => Padding(
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
      ),
    ),
  );

}