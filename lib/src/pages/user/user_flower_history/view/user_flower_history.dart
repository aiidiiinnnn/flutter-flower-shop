import 'package:flower_shop/src/pages/user/user_flower_history/view/widget/user_flower_history_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

import '../controller/user_flower_history_controller.dart';

class UserFlowerHistory extends  GetView<UserFlowerHistoryController>{
  const UserFlowerHistory({super.key});

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
    else if(controller.historyList.isEmpty){
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
    itemCount: controller.historyList.length,
    itemBuilder: (_,index) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: Column(
        children: [
          Text(controller.historyList[index].date,style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 17
          )),
          SizedBox(
            child: Expanded(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.historyList[index].purchaseList.length,
                  itemBuilder: (_,index2) => UserFlowerHistoryCard(
                      historyCart: controller.historyList[index].purchaseList[index2],
                      index: index
                  )
              ),
            ),
          )
        ],
      ),
    ),
  ));

}