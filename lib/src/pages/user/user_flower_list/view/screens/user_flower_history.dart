import 'package:flower_shop/src/pages/user/user_flower_list/view/widget/user_flower_history_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_flower_list_controller.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

class UserFlowerHistory extends  GetView<UserFlowerListController>{
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
          body: Obx(() => ListView.builder(
              itemCount: controller.historyList.length,
              itemBuilder: (_,index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                // child: SizedBox(
                //   width: double.infinity,
                //   height: 40,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xff6cba00),
                //     ),
                //     onPressed: ()=>{
                //       showDialog(
                //           context: context,
                //           builder: (BuildContext context) => AlertDialog(
                //             backgroundColor: const Color(0xffe9e9e9),
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(30),
                //             ),
                //             content: Container(
                //               width: 400,
                //               height: 490,
                //               decoration: const BoxDecoration(
                //                   color: Color(0xffe9e9e9)
                //               ),
                //               child: ListView.builder(
                //                   itemCount: controller.purchasedFlowers.length,
                //                   itemBuilder: (_,index) => UserFlowerHistoryCard(
                //                       historyCart: controller.purchasedFlowers[index],
                //                       index: index,
                //                   )
                //               ),
                //             )
                //           )
                //       )
                //     },
                //     child: Text(controller.historyList[index].date),
                //   ),
                // ),
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
          )),
        )
    );
  }

}