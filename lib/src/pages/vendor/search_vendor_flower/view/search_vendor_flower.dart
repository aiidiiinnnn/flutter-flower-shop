import 'dart:async';

import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:flower_shop/src/pages/vendor/search_vendor_flower/view/widget/search_vendor_flower_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_ui/taav_ui.dart';

import '../controller/search_vendor_flower_controller.dart';
import '../models/search_vendor_flower_view_model.dart';

class SearchVendorFlower extends GetView<SearchVendorFlowerController> {
  const SearchVendorFlower({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xfff3f7f7),
      appBar: appBar(),
      body: Column(
        children: [
          searchBar(context),
          Expanded(
            child: Obx(
                ()=> _vendorFlower()
              // () => RefreshIndicator(
              //   onRefresh: controller.getFlowersByVendorId,
              //   child: _pageContent(),
              // ),
            ),
          )
        ],
      ),
    ));
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xfff3f7f7),
      title: Text(
        locale.LocaleKeys.vendor_search_page.tr,
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

  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          searchTextFormField(),
          filterButton(context),
        ],
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
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff71cc47),
                      ),
                      onPressed: () {
                        controller.onTapFilter();
                        flowerShowDialog(context);
                      },
                      child: const Center(
                          child: Icon(Icons.tune_outlined, size: 17)),
                    ),
        ));
  }

  Form searchTextFormField() {
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
                Timer(const Duration(milliseconds: 1500), () {
              text = controller.searchController.text.toLowerCase();
              controller.getFlowersWithHandler(resetData: false,nameToSearch: text);
            })
          },
          style: const TextStyle(color: Color(0xff050a0a)),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_outlined),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff050a0a))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff050a0a))),
            labelText: locale.LocaleKeys.vendor_search.tr,
            labelStyle: const TextStyle(color: Color(0xff050a0a)),
          ),
          controller: controller.searchController,
        ),
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
            Text(locale.LocaleKeys.vendor_no_flower_founded.tr,
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
            onPressed: controller.getFlowersByVendorId,
            child: const Icon(Icons.refresh_outlined)),
      );

  Widget _vendorFlower() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TaavListView<SearchVendorFlowerViewModel>(
          key: controller.searchedFlowersHandler.key,
          items: controller.searchedFlowersHandler.list,
          disableScrollbar: true,
          showRefreshIndicator: false,
          padding: EdgeInsets.zero,
          // onRefreshData: controller.getFlowersWithHandler,
          onLoadMoreData: () => controller.getFlowersWithHandler(resetData: false),
          showError: controller.searchedFlowersHandler.showError.value,
          hasMoreData: controller.searchedFlowersHandler.hasMoreData.value,
          itemBuilder: (
              final context,
              final item,
              final index,
              ) => SearchVendorFlowerCard(
              vendorFlower: item,
              index: index)
      ),
      // child: ListView.builder(
      //     shrinkWrap: true,
      //     itemCount: controller.searchList.length,
      //     itemBuilder: (_, index) => SearchVendorFlowerCard(
      //         vendorFlower: controller.searchList[index], index: index))

  );



  Future<dynamic> flowerShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xffe9e9e9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text(
          locale.LocaleKeys.vendor_filter.tr,
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
                      Text(locale.LocaleKeys.vendor_categories.tr,
                          style: const TextStyle(
                            color: Color(0xff050a0a),
                            fontSize: 15,
                          ))
                    ],
                  ),
                ),
                (controller.isCheckedCategory.value)
                    ? SizedBox(
                        height: 40,
                        child: DropdownButton<String>(
                            onChanged: (value) {
                              controller.setSelectedCategory(value!);
                            },
                            value: controller.selectedCategory.value,
                            items: controller.categoryList
                                .map<DropdownMenuItem<String>>((dynamic value) {
                              return DropdownMenuItem(
                                  value: value, child: Text("$value"));
                            }).toList()))
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
                      Text(locale.LocaleKeys.vendor_colors.tr,
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
                                padding: const EdgeInsets.all(4.0),
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
                                                height: 17,
                                                width: 17,
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
                      Text(locale.LocaleKeys.vendor_price_range.tr,
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
                              // inactiveTrackColor: Color(0xff9d9d9d),
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
                    Text(locale.LocaleKeys.vendor_delete_filter.tr),
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
                    Text(locale.LocaleKeys.vendor_filter.tr),
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
