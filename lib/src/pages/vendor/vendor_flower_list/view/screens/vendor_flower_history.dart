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
          // body: Obx(() => ListView.builder(
          //     itemCount: controller.historyList.length,
          //     itemBuilder: (_,index)
          //     {
          //       RxList<CartFlowerViewModel> salesList = RxList();
          //       for(final flower in controller.historyList){
          //         for(final purchase in flower.purchaseList){
          //           if(purchase.vendorId==controller.vendorId!){
          //             salesList.add(purchase);
          //           }
          //         }
          //       }
          //       return Padding(
          //         padding:
          //             const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          //         child: Column(
          //           children: [
          //             Text(controller.historyList[index].date,
          //                 style: const TextStyle(
          //                     fontWeight: FontWeight.w400, fontSize: 17)),
          //             SizedBox(
          //               child: Expanded(
          //                 child: ListView.builder(
          //                     physics: const NeverScrollableScrollPhysics(),
          //                     shrinkWrap: true,
          //                     itemCount: salesList.length,
          //                     itemBuilder: (_, index2) => VendorFlowerHistoryCard(
          //                         historyCart: salesList[index2],
          //                         index: index)
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //       );
          //     })),
        );
  }

}