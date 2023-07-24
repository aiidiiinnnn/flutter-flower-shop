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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       SizedBox(
                  //           height: 24.0,
                  //           width: 24.0,
                  //           child: Theme(
                  //             data: ThemeData(
                  //                 unselectedWidgetColor: Colors.blue
                  //             ),
                  //             child: Obx(() => Checkbox(
                  //                 value: controller.isCheckedCategory.value,
                  //                 onChanged: (value) {
                  //                   controller.isCheckedCategory.value=value!;
                  //                 }
                  //             ),),
                  //           )),
                  //       const SizedBox(width: 10.0),
                  //       const Text("Categories", style: TextStyle(
                  //           color: Color(0xff050a0a),
                  //           fontSize: 12,
                  //           fontFamily: 'Rubric')
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // (controller.isCheckedCategory.value) ?
                  // SizedBox(
                  //     height: 30,
                  //     child: DropdownButton<String>(
                  //         hint: const Text('Categories'),
                  //         onChanged: (value) {
                  //           controller.setSelectedCategory(value!);
                  //         },
                  //         value: controller.selectedCategory.value,
                  //         items: controller.categoriesFromJson.map<DropdownMenuItem<String>>(
                  //                 (dynamic value){
                  //               return DropdownMenuItem(
                  //                   value: value,
                  //                   child: Text("$value")
                  //               );
                  //             }).toList()
                  //     )
                  // ) : const SizedBox(),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.blue
                              ),
                              child: Obx(() => Checkbox(
                                  value: controller.isCheckedColor.value,
                                  onChanged: (value) {
                                    controller.isCheckedColor.value=value!;
                                  }
                              ),),
                            )),
                        const SizedBox(width: 10.0),
                        const Text("Colors", style: TextStyle(
                            color: Color(0xff050a0a),
                            fontSize: 12,
                            fontFamily: 'Rubric')
                        )
                      ],
                    ),
                  ),
                  (controller.isCheckedColor.value) ?
                  SizedBox(
                    height: 30,
                    child: Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.colorList.length,
                            itemBuilder: (_,index) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                    onTap: ()=> controller.setSelectedColor(controller.colorList[index]),
                                    child: Obx(() => (controller.selectedColor==controller.colorList[index]) ?
                                    Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        color: Color(controller.colorList[index]),
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(200),
                                      ),
                                      child: const Center(child: Icon(Icons.check,size: 16,color: Colors.white,)),
                                    ): Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Color(controller.colorList[index]),
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(200),
                                      ),
                                    )
                                    )
                                )
                            )
                        )
                    ),
                  ): const SizedBox(),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.blue
                              ),
                              child: Obx(() => Checkbox(
                                  value: controller.isCheckedPrice.value,
                                  onChanged: (value) {
                                    controller.isCheckedPrice.value=value!;
                                  }
                              ),),
                            )),
                        const SizedBox(width: 10.0),
                        const Text("Range Price", style: TextStyle(
                            color: Color(0xff050a0a),
                            fontSize: 12,
                            fontFamily: 'Rubric')
                        )
                      ],
                    ),
                  ),
                  (controller.isCheckedPrice.value) ?
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
                  )) : const SizedBox()
                ]
            )
        ),),

        actions: [
          Center(
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.filter_list_off_outlined),
                    Text("Delete Filter"),
                  ],
                ),
                onPressed: () => {
                  controller.deleteFilter(),
                  Navigator.of(context).pop(),
                },
              ),
            ),
          ),
          ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.filter_list_outlined),
                Text(locale.LocaleKeys.vendor_flower_home_filter.tr),
              ],
            ),
            onPressed: () => {
              controller.filterFlowers(),
              Navigator.of(context).pop(),
            },
          ),
        ],
      ),

    );
  }
}
