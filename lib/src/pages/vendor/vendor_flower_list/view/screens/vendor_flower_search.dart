import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/widget/vendor_flower_search_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;
import '../../controller/vendor_flower_list_controller.dart';

class VendorFlowerSearch extends  GetView<VendorFlowerListController> {
  const VendorFlowerSearch({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xfff3f7f7),
          appBar: AppBar(
            backgroundColor: const Color(0xfff3f7f7),
            title:Text(locale.LocaleKeys.vendor_flower_home_Search_page.tr,style: const TextStyle(
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
                            text= controller.searchController.text.toLowerCase(),
                            controller.searchFlower(text),
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
                            labelText: locale.LocaleKeys.vendor_flower_home_Search.tr,
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
                        onPressed: ()=> flowerShowDialog(context),
                        child: const Center(child: Icon(Icons.tune_outlined,size: 17)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.searchedFlowersList.length,
                    itemBuilder: (_,index) => VendorFlowerSearchCard(
                        vendorFlower: controller.searchedFlowersList[index],
                        index: index
                    )
                ))
              )
            ],
          ),
        )
    );
  }

  Future<dynamic> flowerShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: const Color(0xffe9e9e9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Text(locale.LocaleKeys.vendor_flower_home_filter.tr),
          content: Obx(() => Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                  color: Color(0xffe9e9e9)),
              child: Column(
                  children: [
                    // SizedBox(
                    //   child: Obx( () => DropdownButton(
                    //       hint: const Text('Categories'),
                    //       onChanged: (value) {
                    //         controller.setSelected(value!);
                    //       },
                    //       value: controller.selectedCategory.value,
                    //       items: controller.categoryList.map<DropdownMenuItem>(
                    //               (dynamic value){
                    //             return DropdownMenuItem(
                    //                 value: value,
                    //                 child: Text("$value")
                    //             );
                    //           }).toList()
                    //   )),
                    // ),

                    const SizedBox(height: 30),

                    SizedBox(
                      height: 30,
                      child: Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.colorList.length,
                              itemBuilder: (_,index) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Obx(() => Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: (controller.colorsOnTap[index]) ? Colors.grey : Color(controller.colorList[index]),
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        int i=0;
                                        for(final color in controller.colorList){
                                          controller.colorsOnTap[i]=false;
                                          i++;
                                        }
                                        controller.colorsOnTap[index] = !controller.colorsOnTap[index];
                                        controller.selectedColor.value=controller.colorList[index];
                                      }),
                                  ),)
                              )
                          )
                      ),
                    ),

                    const SizedBox(height: 30),

                    Obx(() => RangeSlider(
                      values: controller.currentRangeValues.value,
                      min: controller.minPrice.value,
                      max: controller.maxPrice.value,
                      divisions: controller.division.value,
                      labels: RangeLabels(
                        controller.currentRangeValues.value.start.round().toString(),
                        controller.currentRangeValues.value.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        controller.setRange(values);
                      },
                    ))
                  ]
              )
          ),),

          actions: [
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.filter_list_outlined),
                  Text(locale.LocaleKeys.vendor_flower_home_filter.tr),
                ],
              ),
              onPressed: () => {
                controller.filterFlowers(controller.selectedCategory.value,controller.selectedColor.value),
                Navigator.of(context).pop(),
              },
            ),
          ],
        ),

    );
  }
}
