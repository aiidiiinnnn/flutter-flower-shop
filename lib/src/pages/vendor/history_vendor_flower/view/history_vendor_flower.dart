import 'package:flower_shop/src/pages/user/user_flower_history/view/widget/user_flower_history_card.dart';
import 'package:flower_shop/src/pages/vendor/history_vendor_flower/view/widget/history_vendor_flower_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

import '../controller/history_vendor_flower_controller.dart';

class HistoryVendorFlower extends  GetView<HistoryVendorFlowerController>{
  const HistoryVendorFlower({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xfff3f7f7),
          appBar: AppBar(
            backgroundColor: const Color(0xfff3f7f7),
            title: Text(locale.LocaleKeys.vendor_flower_home_History.tr,style: const TextStyle(
                color: Color(0xff050a0a),
                fontWeight: FontWeight.w600,
                fontSize: 22
            ),),
            iconTheme: const IconThemeData(
              color: Color(0xff050a0a),
              weight: 2,
            ),
          ),
          body: Obx(() => RefreshIndicator(
            onRefresh: controller.purchaseHistory,
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
    else if(controller.salesList.isEmpty){
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_outlined,size: 270),
            Text("Nothing has been purchased yet", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
          ],
        ),
      );
    }
    return _userFlower();
  }

  Widget _retryButton() => Center(
    child: OutlinedButton(
        onPressed: controller.purchaseHistory, child: const Icon(Icons.keyboard_return_outlined)),
  );

  Widget _userFlower() => Obx(() => ListView.builder(
      shrinkWrap: true,
      itemCount: controller.salesList.length,
      itemBuilder: (_, index) => HistoryVendorFlowerCard(
          historyCart: controller.salesList[index]["card"],
          index: index
      )
  ),
  );

}