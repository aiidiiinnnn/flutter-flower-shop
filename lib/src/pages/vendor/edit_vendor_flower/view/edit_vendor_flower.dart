import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import '../../add_vendor_flower/view/widget/custom_add_form_field.dart';
import '../controller/edit_vendor_flower_controller.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

class EditVendorFlower extends  GetView<EditVendorFlowerController>{
  const EditVendorFlower({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xfff3f7f7),
            appBar: AppBar(
              backgroundColor: const Color(0xfff3f7f7),
              title: Text(locale.LocaleKeys.add_vendor_flower_card_edit_flower.tr,style: const TextStyle(
                  color: Color(0xff050a0a),
                  fontWeight: FontWeight.w600,
                  fontSize: 22
              ),),
              iconTheme: const IconThemeData(
                color: Color(0xff050a0a),
                weight: 2,
              ),
            ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xffe9e9e9),
                    border: Border.all(color: const Color(0xff9d9d9d)),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: ()=>{
                              _showImagePicker(context)
                            },
                            child: AspectRatio(
                              aspectRatio: 1.65,
                              child: Container(
                                height: 250,
                                width: 250,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Obx(()=> controller.imagePath.isNotEmpty ? AspectRatio(aspectRatio: 2.2,
                                child: Image(image: FileImage(File(controller.imagePath.toString())),fit: BoxFit.fill,)):
                                const Icon(Icons.add_a_photo_outlined,size: 50))),
                            )
                              )
                          ),
                        Form(
                            key: controller.formKey,
                            child: Column(
                              children: [
                                CustomAddFormField(
                                  hintText: locale.LocaleKeys.add_vendor_flower_card_name.tr,
                                  name: locale.LocaleKeys.add_vendor_flower_card_name.tr,
                                  controller: controller.nameController,
                                  validator: controller.nameValidator,
                                  icon: Icons.spa_outlined,
                                ),
                                CustomAddFormField(
                                  hintText: "Description",
                                  name: "Description",
                                  controller: controller.descriptionController,
                                  validator: controller.descriptionValidator,
                                  icon: Icons.description_outlined,
                                ),
                                CustomAddFormField(
                                  hintText: locale.LocaleKeys.vendor_flower_card_description.tr,
                                  name: locale.LocaleKeys.vendor_flower_card_description.tr,
                                  controller: controller.priceController,
                                  validator: controller.priceValidator,
                                  icon: Icons.attach_money_outlined,
                                ),
                                CustomAddFormField(
                                  hintText: locale.LocaleKeys.add_vendor_flower_card_price.tr,
                                  name: locale.LocaleKeys.add_vendor_flower_card_price.tr,
                                  controller: controller.countController,
                                  validator: controller.countValidator,
                                  icon: Icons.numbers_outlined,
                                ),
                              ],
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: controller.categoryKey,
                              child: TextFormField(
                                enableSuggestions: false,
                                style: const TextStyle(color: Color(0xff050a0a)),
                                decoration: InputDecoration(
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: InkWell(
                                        splashColor: const Color(0xffc4c4c4),
                                        customBorder: const CircleBorder(),
                                        onTap: ()=>controller.addCategory(controller.categoryController.text),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:8),
                                          child: Container(
                                              width: 65,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: const Color(0xff050a0a)),
                                                  color: const Color(0xffc4c4c4)
                                              ),
                                              child: const Icon(Icons.add,size:25)
                                            // child:
                                          ),
                                        )
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.category_outlined),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff050a0a))
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff050a0a))
                                  ),
                                  labelText: locale.LocaleKeys.add_vendor_flower_card_category.tr,
                                  labelStyle: const TextStyle(color: Color(0xff050a0a)),
                                ),
                                validator: controller.categoryValidator,
                                controller: controller.categoryController,
                              ),
                            )
                        ),
                        Obx(() => (controller.categoryList.isNotEmpty) ?
                        SizedBox(
                            height: controller.space.value,
                            child: Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.categoryList.length,
                                itemBuilder: (_, index) => Chip(
                                  label: Text(controller.categoryList[index]),
                                  onDeleted: () => {controller.categoryList.removeAt(index)},
                                ),),
                            )
                        ) : const SizedBox(height: 0)),

                        ElevatedButton(
                          onPressed: ()=>{
                            _colorPickerDialog(context)
                          },
                          child: Text(locale.LocaleKeys.add_vendor_flower_card_color_picker.tr),
                        ),
                        Obx(() => (controller.colors.isNotEmpty) ?
                        SizedBox(
                          height: controller.space.value,
                          child: Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.colors.length,
                                  itemBuilder: (_,index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Color(controller.colors[index]),
                                          border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                      )
                                  )
                              )
                          ),
                        ) : const SizedBox(height: 0)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff6cba00),
                                ),
                                onPressed: ()=>controller.editVendorFlower(),
                                child: Text(locale.LocaleKeys.add_vendor_flower_card_submit.tr)
                            ),
                          ),
                        ),
                    ]
                  )),
                ),
              ),
            ),
          )
        )
    );
  }

  void _colorPickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(locale.LocaleKeys.add_vendor_flower_card_pick_a_color.tr),
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
              child: Text(locale.LocaleKeys.add_vendor_flower_card_got_it.tr),
              onPressed: () {
                controller.changeColor(controller.currentColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

  void _showImagePicker(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Column(
                    children: [
                      const Icon(Icons.image_outlined,size: 60),
                      Text(locale.LocaleKeys.add_vendor_flower_card_gallery.tr,style: const TextStyle(
                          fontSize: 16
                      ),),
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
                      const Icon(Icons.camera_alt_outlined,size: 60),
                      Text(locale.LocaleKeys.add_vendor_flower_card_camera.tr,style: const TextStyle(
                          fontSize: 16
                      ),),
                    ],
                  ),
                  onTap: () {
                    controller.imageFromCamera();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        )
    );
  }

}