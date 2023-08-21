import 'dart:io';

import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:taav_ui/taav_ui.dart';

import '../../add_vendor_flower/view/widget/number_add_form_field.dart';
import '../controller/add_vendor_flower_controller.dart';
import '../models/categories/categories_view_model.dart';
import 'widget/custom_add_form_field.dart';

class AddVendorFlower extends GetView<AddVendorFlowerController> {
  const AddVendorFlower({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xfff3f7f7),
            appBar: appBar(),
            body: Center(
                child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xffe9e9e9),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff9d9d9d).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(4, 4), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      addImage(context),
                      addFlowerForm(),
                      addCategory(),
                      showCategories(),
                      addColor(context),
                      showColors(),
                      submitButton(),
                    ]),
                  ),
                ),
              ),
            ))));
  }

  Padding submitButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6cba00),
            ),
            onPressed: () => controller.addVendorFlower(),
            child: Obx(
              () => (controller.isLoadingSubmit.value)
                  ? const Center(
                      child:
                          SizedBox(width: 50, child: LinearProgressIndicator()),
                    )
                  : Text(locale.LocaleKeys.vendor_submit.tr),
            )),
      ),
    );
  }

  Obx showColors() {
    return Obx(() => (controller.colorList.isNotEmpty)
        ? SizedBox(
            height: controller.space.value,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: controller.colorList.length,
                itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () =>
                          controller.removeColor(controller.colorList[index]),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: controller.colorList[index],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                    ))),
          )
        : const SizedBox(height: 0));
  }

  Padding addColor(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height: 40,
        width: 120,
        child: ElevatedButton(
          onPressed: () => {_colorPickerDialog(context)},
          child: Obx(() => (controller.isLoadingColor.value)
              ? const Center(
                  child: SizedBox(width: 50, child: LinearProgressIndicator()),
                )
              : Text(locale.LocaleKeys.vendor_color_picker.tr)),
        ),
      ),
    );
  }

  Obx showCategories() {
    return Obx(() => (controller.categoryList.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
                height: controller.space.value,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categoryList.length,
                  itemBuilder: (_, index) => Chip(
                    label: Text(controller.categoryList[index]),
                    onDeleted: () => {controller.categoryList.removeAt(index)},
                  ),
                )),
          )
        : const SizedBox(height: 0));
  }

  Padding addCategory() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: Row(
          children: [
            Expanded(
              child: TaavTextFieldTheme(
                themeData: TaavTextFieldThemeData(
                  labelTextStyle: const TextStyle(color: Color(0xff050a0a)),
                  iconColor: Colors.white24,
                  hintTextStyle: const TextStyle(color: Color(0xff050a0a)),
                  isFilled: false,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Color(0xff050a0a)),
                  ),
                ),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Obx(() => TaavTypeAheadField<CategoriesViewModel>(
                    hint: 'Category',
                    suffixIcon: TaavIconButton.flat(
                      icon: (controller.isLoadingCategory.value)
                          ? Icons.circle_outlined
                          : Icons.add,
                      shape: TaavWidgetShape.round,
                      padding: const EdgeInsets.all(4),
                      onTap: () {
                        controller.addCategory(controller.categoryController.text);
                        controller.categoryController.clear();
                      },
                    ),
                    suggestionsProvider: controller.autoCompleteCategories,
                    itemAsString: (final e) => e.name ?? '',
                    direction: AxisDirection.up,
                    suggestionsBoxDecoration: const TaavSuggestionsBoxDecoration(
                      constraints: BoxConstraints(maxHeight: 200),
                    ),
                    onSubmitted: (String? selection) {
                      if (controller.categoryController.text.isEmpty) {
                        Get.snackbar('Category', "Can't add empty category");
                        return;
                      }
                      for (final categoryName in controller.categoryList) {
                        if (categoryName.toLowerCase().trim() == controller.categoryController.text.toLowerCase().trim()) {
                          Get.snackbar('Category', "Can't add duplicate category");
                          return;
                        }
                      }
                      controller.onSelectedCategory(selection!);
                    },
                    debounceDuration: const Duration(milliseconds: 300),
                    suggestionsBoxController: controller.autoCompleteController,
                    controller: controller.categoryController,
                  ),)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Form addFlowerForm() {
    return Form(
        key: controller.formKey,
        child: Column(
          children: [
            CustomAddFormField(
              hintText: locale.LocaleKeys.vendor_name.tr,
              name: locale.LocaleKeys.vendor_name.tr,
              controller: controller.nameController,
              validator: controller.nameValidator,
              icon: Icons.spa_outlined,
              maxLength: 15,
            ),
            CustomAddFormField(
              hintText: locale.LocaleKeys.vendor_add_description.tr,
              name: locale.LocaleKeys.vendor_add_description.tr,
              controller: controller.descriptionController,
              validator: controller.descriptionValidator,
              icon: Icons.description_outlined,
              maxLength: 240,
            ),
            NumberAddFormField(
              hintText: locale.LocaleKeys.vendor_price.tr,
              name: locale.LocaleKeys.vendor_price.tr,
              controller: controller.priceController,
              validator: controller.priceValidator,
              icon: Icons.attach_money_outlined,
            ),
            NumberAddFormField(
              hintText: locale.LocaleKeys.vendor_count.tr,
              name: locale.LocaleKeys.vendor_count.tr,
              controller: controller.countController,
              validator: controller.countValidator,
              icon: Icons.numbers_outlined,
            ),
          ],
        ));
  }

  Obx addImage(BuildContext context) {
    return Obx(
      () => controller.imagePath.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () => {_showImagePicker(context)},
                  child: AspectRatio(
                    aspectRatio: 1.65,
                    child: Container(
                        height: 250,
                        width: 250,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child:
                            const Icon(Icons.add_a_photo_outlined, size: 50)),
                  )))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 250,
                  width: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: AspectRatio(
                            aspectRatio: 2.2,
                            child: Image(
                              image: FileImage(
                                  File(controller.imagePath.toString())),
                              fit: BoxFit.fill,
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                                splashColor: Colors.blue,
                                customBorder: const CircleBorder(),
                                onTap: () {
                                  _showImagePicker(context);
                                },
                                child: Container(
                                    width: 110,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: const Color(0xffc4c4c4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 23))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                                splashColor: Colors.blue,
                                customBorder: const CircleBorder(),
                                onTap: () {
                                  _deleteImageDialog(context);
                                },
                                child: Container(
                                    width: 110,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: const Color(0xffc4c4c4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        locale
                                            .LocaleKeys.vendor_remove_image.tr,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ))),
                          ),
                        ],
                      )
                    ],
                  ))),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xfff3f7f7),
      title: Text(
        locale.LocaleKeys.vendor_add_flower.tr,
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

  void _colorPickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(locale.LocaleKeys.vendor_pick_a_color.tr),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: controller.pickerColor,
                  onColorChanged: (Color value) {
                    controller.currentColor = value;
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text(locale.LocaleKeys.vendor_got_it.tr),
                  onPressed: () {
                    controller.addColor(controller.currentColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _deleteImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(locale.LocaleKeys.vendor_delete.tr),
          content: Text(
              locale.LocaleKeys.vendor_are_you_sure_you_want_to_delete_this.tr),
          actions: [
            TextButton(
                child: Text(locale.LocaleKeys.vendor_cancel.tr),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text(locale.LocaleKeys.vendor_continue.tr),
              onPressed: () {
                controller.deleteImage();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showImagePicker(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            locale.LocaleKeys.vendor_add_image.tr,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              // color: Color(0xff050a0a)
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Divider(
                        height: 20,
                        color: Color(0xff9d9d9d),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            child: Column(
                              children: [
                                const Icon(Icons.image_outlined, size: 55),
                                Text(
                                  locale.LocaleKeys.vendor_gallery.tr,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            onTap: () {
                              controller.imageFromGallery();
                              Navigator.pop(context);
                            },
                          ),
                          InkWell(
                            child: Column(
                              children: [
                                const Icon(Icons.camera_alt_outlined, size: 55),
                                Text(
                                  locale.LocaleKeys.vendor_camera.tr,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            onTap: () {
                              controller.imageFromCamera();
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 50, bottom: 20, left: 15, right: 15),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(locale.LocaleKeys.vendor_cancel.tr),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }
}
