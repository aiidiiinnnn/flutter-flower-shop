import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/widget/vendor_flower_search_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../controller/user_flower_list_controller.dart';


class UserFlowerSearch extends  GetView<UserFlowerListController> {
  const UserFlowerSearch({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xfff3f7f7),
          appBar: AppBar(
            backgroundColor: const Color(0xfff3f7f7),
            title: const Text("Vendor Flower Search",style: TextStyle(
                color: Color(0xff050a0a),
                fontWeight: FontWeight.w600,
                fontSize: 22
            ),),
            iconTheme: const IconThemeData(
              color: Color(0xff050a0a),
              weight: 2,
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Form(
                      key: controller.searchKey,
                      child: SizedBox(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                          enableSuggestions: false,
                          onChanged: (text) => {
                            // text= controller.searchController.text.toLowerCase(),
                            // controller.searchFlower(text),
                          },
                          style: const TextStyle(color: Color(0xff050a0a)),
                          decoration: InputDecoration(
                            prefixIcon: InkWell(
                                onTap: () => {},
                                child: const Icon(Icons.search_outlined)
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff050a0a))
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff050a0a))
                            ),
                            labelText: "Search",
                            labelStyle: const TextStyle(color: Color(0xff050a0a)),
                          ),
                          controller: controller.searchController,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff71cc47),
                        ),
                        onPressed: ()=>{},
                        child: const Center(child: Icon(Icons.tune_outlined,size: 17)),
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   child: Obx(() => ListView.builder(
              //       shrinkWrap: true,
              //       itemCount: controller.searchedFlowersList.length,
              //       itemBuilder: (_,index) => VendorFlowerSearchCard(
              //           vendorFlower: controller.searchedFlowersList[index],
              //           index: index
              //       )
              //   ))
              // )
            ],
          ),
        )
    );
  }
}
