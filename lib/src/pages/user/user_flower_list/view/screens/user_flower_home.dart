import 'dart:convert';
import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:flower_shop/src/pages/user/user_flower_list/view/widget/user_flower_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_ui/taav_ui.dart';

import '../../../../../../flower_shop.dart';
import '../../controller/user_flower_list_controller.dart';

class UserFlowerHome extends GetView<UserFlowerListController> {
  const UserFlowerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xfff3f7f7),
      appBar: appBar(),
      drawer: userDrawer(context),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: controller.getUserById,
          child: _pageContent(context),
        ),
      ),
    ));
  }

  Obx userDrawer(BuildContext context) {
    return Obx(
      () => Drawer(
        backgroundColor: const Color(0xfff3f7f7),
        child: (controller.isLoadingDrawer.value)
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration:
                            const BoxDecoration(color: Color(0xff6cba00)),
                      ),
                      Positioned(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 90),
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color(0xff7f8283)),
                              child: controller.user!.imagePath.isNotEmpty
                                  ? SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.memory(
                                        base64Decode(
                                            controller.user!.imagePath),
                                        fit: BoxFit.cover,
                                      ))
                                  : const Icon(Icons.person,
                                      color: Colors.white, size: 120),
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
                            child: Text(
                              controller.user!.firstName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Text(
                              controller.user!.lastName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      )),
                  Text(
                    controller.user!.email,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  const Divider(
                    height: 20,
                    color: Color(0xff9d9d9d),
                    thickness: 1,
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 10, top: 20),
                    child: InkWell(
                      onTap: () => {
                        Navigator.of(context).pop(),
                        controller.goToSearch()
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.search_outlined),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 4),
                            child: Text(
                              locale.LocaleKeys.user_search.tr,
                              style: const TextStyle(
                                  fontSize: 17, color: Color(0xff050a0a)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 10, top: 30),
                    child: InkWell(
                      onTap: () => {
                        Navigator.of(context).pop(),
                        controller.goToHistory()
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.history_outlined),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 4),
                            child: Text(
                              locale.LocaleKeys.user_history.tr,
                              style: const TextStyle(
                                  fontSize: 17, color: Color(0xff050a0a)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 10, top: 30),
                    child: InkWell(
                      onTap: () => {
                        Navigator.of(context).pop(),
                        controller.logOut(),
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.login_outlined),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 4),
                            child: Text(
                              locale.LocaleKeys.user_Logout.tr,
                              style: const TextStyle(
                                  fontSize: 17, color: Color(0xff050a0a)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 10, top: 30),
                    child: InkWell(
                      onTap: () => {
                        Navigator.of(context).pop(),
                        Get.updateLocale(const Locale('en', 'US'))
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.language_outlined),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 4),
                            child: Text(
                              "English",
                              style: TextStyle(
                                  fontSize: 17, color: Color(0xff050a0a)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 10, top: 30),
                    child: InkWell(
                      onTap: () => {
                        Navigator.of(context).pop(),
                        Get.updateLocale(const Locale('fa', 'IR'))
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.language_outlined),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 4),
                            child: Text(
                              "فارسی",
                              style: TextStyle(
                                  fontSize: 17, color: Color(0xff050a0a)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xfff3f7f7),
      title: Text(
        locale.LocaleKeys.user_flower_list.tr,
        style: const TextStyle(
            color: Color(0xff050a0a),
            fontWeight: FontWeight.w600,
            fontSize: 22),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xff050a0a),
        weight: 2,
      ),
      actions: [
        Obx(() => TaavBadge(
          showAnimation: true,
          badgeContent: TaavText(
            "${controller.countInCart}",
            style: const TextStyle(
              color: TaavColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          badgePosition: TaavBadgePosition.topEnd(top: -1, end: 3),
          animationType: TaavBadgeAnimationType.scale,
          // animationDuration: const Duration(seconds: 1),
          badgeShape: TaavWidgetShape.round,
          badgeColor: TaavColors.blue,
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xff050a0a),
              weight: 2,
            ),
            onPressed: () async {
              await Get.toNamed(
                  "${RouteNames.userFlowerList}${RouteNames.userFlowerHome}${RouteNames.userFlowerCart}");
              controller.getUserById();
            },
          ),
        ),)
      ],
    );
  }

  Widget _pageContent(BuildContext context) {
    if (controller.isLoading.value) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TaavShimmerEffect(
              color: Colors.blue,
              duration: Duration(seconds: 1),
              enabled: true,
              direction: TaavShimmerEffectDirection.bottomRightToTopLeft,
              widthPercent: 0.1,
              pausePercent: 0,
              curve: Curves.decelerate,
              child: Column(
                children: [
                  Icon(Icons.hourglass_empty_outlined,size: 40,),
                  TaavText.heading5('Loading'),
                ],
              )
            ),
          ],
        ),
      );
    } else if (controller.isRetry.value) {
      return _retryButton();
    } else if (controller.flowersList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_outlined, size: 270),
            Text(locale.LocaleKeys.user_there_is_no_flower_here.tr,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
          ],
        ),
      );
    }
    return _userFlower(context);
  }

  Widget _retryButton() => Center(
        child: OutlinedButton(
            onPressed: controller.getUserById,
            child: const Icon(Icons.keyboard_return_outlined)),
      );

  Widget _userFlower(BuildContext context) =>
      Obx(() => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: TaavCarouselSlider.builder(
          itemCount: controller.flowersList.length,
            options: CarouselOptions(
              enlargeCenterPage: true,
              aspectRatio: 2,
              scrollDirection: Axis.vertical,
              // autoPlay: true,
              // pauseAutoPlayOnManualNavigate: true,
            ),
          itemBuilder: (
              final context,
              final itemIndex,
              final pageViewIndex,
              ) =>
              UserFlowerCard(
                  userFlower: controller.flowersList[itemIndex], index: itemIndex)
        ),
      ),);
      // Obx(() => ListView.builder(
      // itemCount: controller.flowersList.length,
      // itemBuilder: (_, index) => UserFlowerCard(
      //     userFlower: controller.flowersList[index], index: index))
}
