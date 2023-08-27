import 'dart:convert';

import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/widget/vendor_flower_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_ui/taav_ui.dart';

import '../../controller/vendor_flower_list_controller.dart';

class VendorFlowerHome extends GetView<VendorFlowerListController> {
  const VendorFlowerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: TaavScaffold(
      backgroundColor: const Color(0xfff3f7f7),
      appBar: appBar(),
      drawer: Obx(
        () => vendorDrawer(context),
      ),
      body: _vendorFlower(),
          padding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
    ));
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xfff3f7f7),
      title: Text(
        locale.LocaleKeys.vendor_flower_list.tr,
        style: const TextStyle(
            color: Color(0xff050a0a),
            fontWeight: FontWeight.w600,
            fontSize: 22),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xff050a0a),
        weight: 2,
      ),
    );
  }

  Drawer vendorDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xfff3f7f7),
      child: (controller.isLoadingDrawer.value)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                drawerProfile(),
                drawerNameAndLastName(),
                Text(
                  controller.vendor!.email,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300),
                ),
                const Divider(
                  height: 20,
                  color: Color(0xff9d9d9d),
                  thickness: 1,
                ),
                drawerSearchButton(context),
                drawerHistoryButton(context),
                drawerLogoutButton(context),
                drawerEnglishButton(context),
                drawerPersianButton(context),
              ],
            ),
    );
  }

  Stack drawerProfile() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xff6cba00)),
        ),
        drawerProfilePicture(),
      ],
    );
  }

  Padding drawerPersianButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, top: 30),
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
              child: Text(
                "فارسی",
                style: TextStyle(fontSize: 17, color: Color(0xff050a0a)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding drawerEnglishButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, top: 30),
      child: InkWell(
        onTap: () {
          Get.updateLocale(const Locale('en', 'US'));
          Navigator.of(context).pop();
        },
        child: const Row(
          children: [
            Icon(Icons.language_outlined),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 4),
              child: Text(
                "English",
                style: TextStyle(fontSize: 17, color: Color(0xff050a0a)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding drawerLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, top: 30),
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
                locale.LocaleKeys.vendor_logout.tr,
                style: const TextStyle(fontSize: 17, color: Color(0xff050a0a)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding drawerHistoryButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, top: 30),
      child: InkWell(
        onTap: () => {Navigator.of(context).pop(), controller.goToHistory()},
        child: Row(
          children: [
            const Icon(Icons.history_outlined),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4),
              child: Text(
                locale.LocaleKeys.vendor_history.tr,
                style: const TextStyle(fontSize: 17, color: Color(0xff050a0a)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding drawerSearchButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, top: 20),
      child: InkWell(
        onTap: () => {Navigator.of(context).pop(), controller.goToSearch()},
        child: Row(
          children: [
            const Icon(Icons.search_outlined),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4),
              child: Text(
                locale.LocaleKeys.vendor_search.tr,
                style: const TextStyle(fontSize: 17, color: Color(0xff050a0a)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding drawerNameAndLastName() {
    return Padding(
        padding: const EdgeInsetsDirectional.only(start: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                controller.vendor!.firstName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                controller.vendor!.lastName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ));
  }

  Positioned drawerProfilePicture() {
    return Positioned(
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
            child: controller.vendor!.imagePath.isNotEmpty
                ? SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.memory(
                      base64Decode(controller.vendor!.imagePath),
                      fit: BoxFit.cover,
                    ))
                : const Icon(Icons.person, color: Colors.white, size: 120),
          ),
        ),
      ),
    );
  }

  Widget _vendorFlower() => Obx(
    () => TaavGridView<VendorFlowerViewModel>(
      key: controller.flowersHandler.key,
      items: controller.flowersHandler.list,
      crossAxisCount: const CrossAxisCount(xs: 2, lg: 4),
      crossAxisItemSize: 200,
      disableScrollbar: true,
      showRefreshIndicator: false,
      padding: EdgeInsets.zero,
      // onRefreshData: controller.getFlowersWithHandler,
      onLoadMoreData: () => controller.getFlowersWithHandler(resetData: false),
      showError: controller.flowersHandler.showError.value,
      hasMoreData: controller.flowersHandler.hasMoreData.value,
      itemBuilder: (
          final context,
          final item,
          final index,
          ) => VendorFlowerCard(
              vendorFlower: item,
              index: index
          )
    ),
  );

}
