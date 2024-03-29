import 'dart:async';

import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:flower_shop/src/pages/user/user_flower_search/view/widget/user_flower_search_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_ui/taav_ui.dart';

import '../controller/user_flower_search_controller.dart';

class UserFlowerSearch extends GetView<UserFlowerSearchController> {
  const UserFlowerSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xfff3f7f7),
      appBar: appBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                searchField(),
                filterButton(context),
              ],
            ),
          ),
          searchContent()
        ],
      ),
    ));
  }

  Expanded searchContent() {
    return Expanded(
      child: Obx(
        () => RefreshIndicator(
          onRefresh: controller.getUserById,
          child: _pageContent(),
        ),
      ),
    );
  }

  SizedBox filterButton(BuildContext context) {
    return SizedBox(
        width: 50,
        height: 50,
        child: Obx(
          () => (controller.isLoading.value)
              ? const ElevatedButton(
                  onPressed: null,
                  child: Center(child: Icon(Icons.tune_outlined, size: 17)),
                )
              : (controller.categoryList.isEmpty ||
                      controller.colorsFromJson.isEmpty ||
                      controller.priceList.isEmpty)
                  ? const ElevatedButton(
                      onPressed: null,
                      child: Center(child: Icon(Icons.tune_outlined, size: 17)),
                    )
                  : (controller.isFilterDisable.value)
                      ? const ElevatedButton(
                          onPressed: null,
                          child: Center(
                              child: Icon(Icons.tune_outlined, size: 17)),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff71cc47),
                          ),
                          onPressed: () {
                            controller.onTapFilter();
                            filterShowDialog(context);
                          },
                          child: const Center(
                              child: Icon(Icons.tune_outlined, size: 17)),
                        ),
        ));
  }

  Form searchField() {
    return Form(
      key: controller.searchKey,
      child: SizedBox(
        width: 300,
        height: 50,
        child: TextFormField(
          enableSuggestions: false,
          onChanged: (text) => {
            if (controller.deBouncer?.isActive ?? false)
              controller.deBouncer?.cancel(),
            controller.deBouncer =
                Timer(const Duration(milliseconds: 2000), () {
              text = controller.searchController.text.toLowerCase();
              controller.searchFlowers(text);
            })
          },
          style: const TextStyle(color: Color(0xff050a0a)),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_outlined),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff050a0a))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff050a0a))),
            labelText: locale.LocaleKeys.user_search.tr.tr,
            labelStyle: const TextStyle(color: Color(0xff050a0a)),
          ),
          controller: controller.searchController,
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xfff3f7f7),
      title: Text(
        locale.LocaleKeys.user_search_page.tr,
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

  Widget _pageContent() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    } else if (controller.isRetry.value) {
      return _retryButton();
    } else if (controller.searchList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_outlined, size: 270),
            Text(locale.LocaleKeys.user_no_flower_founded.tr,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
          ],
        ),
      );
    }
    return _vendorFlower();
  }

  Widget _retryButton() => Center(
        child: OutlinedButton(
            onPressed: controller.getUserById,
            child: const Icon(Icons.refresh_outlined)),
      );

  Widget _vendorFlower() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.searchList.length,
          itemBuilder: (_, index) => UserFlowerSearchCard(
              searchFlower: controller.searchList[index], index: index)));

  Future<dynamic> filterShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xffe9e9e9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text(
          locale.LocaleKeys.user_filter.tr,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 27),
        ),
        content: Obx(
          () => Container(
              width: 300,
              height: 330,
              decoration: const BoxDecoration(color: Color(0xffe9e9e9)),
              child: Column(children: [
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
                              unselectedWidgetColor: const Color(0xff050a0a),
                            ),
                            child: Obx(
                              () => Checkbox(
                                  activeColor: const Color(0xff9d9d9d),
                                  value: controller.isCheckedCategory.value,
                                  onChanged: (value) {
                                    controller.isCheckedCategory.value = value!;
                                  }),
                            ),
                          )),
                      const SizedBox(width: 10.0),
                      Text(locale.LocaleKeys.user_categories.tr,
                          style: const TextStyle(
                            color: Color(0xff050a0a),
                            fontSize: 15,
                          ))
                    ],
                  ),
                ),
                (controller.isCheckedCategory.value)
                ? TaavDropdownTheme(
                  themeData: TaavDropdownThemeData(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                    ),
                    popupBorderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    fillColor: const Color(0xffe9e9e9),
                    isFilled: true,
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 2, color: Color(0xff050a0a)),
                    ),
                    labelTextStyle: const TextStyle(color: Color(0xff050a0a)),
                    hintTextStyle: const TextStyle(color: Color(0xff050a0a)),
                    selectedItemTextStyle: const TextStyle(color: Color(0xff050a0a)),
                    iconColor: const Color(0xff050a0a),
                  ),
                  child: TaavDropdown<String>(
                    onClearIconTap: ()=> controller.selectedCategory.value="",
                    label: 'Category',
                    items: controller.categoryList.toList(),
                    showClearButton: true,
                    popupShape: TaavWidgetShape.round,
                    mode: Mode.MENU,
                    popupPadding: const EdgeInsets.symmetric(vertical: 8),
                    dropdownShape: TaavWidgetShape.round,
                    onItemsSelected: (value) {
                      if(value!.isNotEmpty){
                        controller.setSelectedCategory(value[0]);
                      }
                      else{
                        controller.setSelectedCategory("");
                      }
                    }
                  ),
                )
                //     ? SizedBox(
                //         height: 40,
                //         child: DropdownButton<String>(
                //             onChanged: (value) {
                //               controller.setSelectedCategory(value!);
                //             },
                //             value: controller.selectedCategory.value,
                //             items: controller.categoryList
                //                 .map<DropdownMenuItem<String>>((dynamic value) {
                //               return DropdownMenuItem(
                //                   value: value, child: Text("$value"));
                //             }).toList())
                // )
                    : const SizedBox(),
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
                                unselectedWidgetColor: const Color(0xff050a0a)),
                            child: Obx(
                              () => Checkbox(
                                  activeColor: const Color(0xff9d9d9d),
                                  value: controller.isCheckedColor.value,
                                  onChanged: (value) {
                                    controller.isCheckedColor.value = value!;
                                  }),
                            ),
                          )),
                      const SizedBox(width: 10.0),
                      Text(locale.LocaleKeys.user_colors.tr,
                          style: const TextStyle(
                            color: Color(0xff050a0a),
                            fontSize: 15,
                          ))
                    ],
                  ),
                ),
                (controller.isCheckedColor.value)
                    ? SizedBox(
                        height: 30,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.colorsFromJson.length,
                            itemBuilder: (_, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: InkWell(
                                    onTap: () => controller.setSelectedColor(
                                        controller.colorsFromJson[index].code),
                                    child: Obx(() => (controller
                                                .selectedColor.value ==
                                            controller
                                                .colorsFromJson[index].code)
                                        ? Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xfff3f7f7),
                                              border: Border.all(
                                                  color: Color(controller
                                                      .colorsFromJson[index]
                                                      .code)),
                                            ),
                                            child: Center(
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(controller
                                                      .colorsFromJson[index]
                                                      .code),
                                                ),
                                              ),
                                            ))
                                        : Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(controller
                                                  .colorsFromJson[index].code),
                                            ),
                                          ))))),
                      )
                    : const SizedBox(),
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
                                unselectedWidgetColor: const Color(0xff050a0a)),
                            child: Obx(
                              () => Checkbox(
                                  activeColor: const Color(0xff9d9d9d),
                                  value: controller.isCheckedPrice.value,
                                  onChanged: (value) {
                                    controller.isCheckedPrice.value = value!;
                                  }),
                            ),
                          )),
                      const SizedBox(width: 10.0),
                      Text(locale.LocaleKeys.user_price_range.tr,
                          style: const TextStyle(
                            color: Color(0xff050a0a),
                            fontSize: 15,
                          ))
                    ],
                  ),
                ),
                (controller.isCheckedPrice.value)
                    ? Obx(() => SliderTheme(
                          data: const SliderThemeData(
                              thumbColor: Color(0xff9d9d9d),
                              activeTrackColor: Color(0xffcbcbcb),
                              valueIndicatorColor: Colors.blue,
                              activeTickMarkColor: Color(0xff9d9d9d),
                              inactiveTrackColor: Color(0xffcbcbcb),
                              inactiveTickMarkColor: Color(0xffe9e9e9),
                              trackHeight: 12,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 20)),
                          child: RangeSlider(
                            values: controller.currentRangeValues.value,
                            min: controller.minPrice.value,
                            max: controller.maxPrice.value,
                            divisions: controller.division.value,
                            labels: RangeLabels(
                              controller.currentRangeValues.value.start
                                  .round()
                                  .toString(),
                              controller.currentRangeValues.value.end
                                  .round()
                                  .toString(),
                            ),
                            onChanged: (RangeValues values) {
                              controller.setRange(values);
                            },
                          ),
                        ))
                    : const SizedBox()
              ])),
        ),
        actions: [
          Center(
            child: SizedBox(
              width: 180,
              height: 40,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.filter_list_off_outlined),
                    Text(locale.LocaleKeys.user_delete_filter.tr),
                  ],
                ),
                onPressed: () => {
                  controller.deleteFilter(),
                  Navigator.of(context).pop(),
                },
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 25, left: 10, right: 10, top: 20),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6cba00),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.filter_list_outlined),
                    Text(locale.LocaleKeys.user_filter.tr),
                  ],
                ),
                onPressed: () => {
                  controller.filterFlowers(),
                  Navigator.of(context).pop(),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
