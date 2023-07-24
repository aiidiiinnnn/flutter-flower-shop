import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_flower_list_controller.dart';
import '../widget/vendor_flower_history_card.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

class VendorFlowerHistory extends  GetView<VendorFlowerListController>{
  const VendorFlowerHistory({super.key});

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
          body: SizedBox(
            child: Expanded(
              child: Obx(() => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.salesList.length,
                  itemBuilder: (_, index) => VendorFlowerHistoryCard(
                      historyCart: controller.salesList[index]["card"],
                      index: index
                  )
              ),
              ),
            ),
          )),
        );
  }

}