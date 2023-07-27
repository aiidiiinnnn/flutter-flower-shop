import 'dart:convert';
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
                        Obx(() => controller.savedImage.isEmpty ?
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
                                      child: const Icon(Icons.add_a_photo_outlined,size: 50)
                                  ),
                                )
                            )
                        ) : Padding(
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
                                      child: AspectRatio(aspectRatio: 2.2, child:
                                      Image.memory(base64Decode(controller.savedImage.value),fit: BoxFit.cover,)),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: InkWell(
                                              splashColor: Colors.blue,
                                              customBorder: const CircleBorder(),
                                              onTap: (){
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
                                                  child: const Icon(Icons.add_a_photo_outlined,size: 23)
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: InkWell(
                                              splashColor: Colors.blue,
                                              customBorder: const CircleBorder(),
                                              onTap: (){
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
                                                  child: const Center(
                                                    child: Text("Remove Image",style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  )
                                              )
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            )
                        ),),
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
                                  name: locale.LocaleKeys.add_vendor_flower_card_price.tr,
                                  controller: controller.priceController,
                                  validator: controller.priceValidator,
                                  icon: Icons.attach_money_outlined,
                                ),
                                CustomAddFormField(
                                  hintText: locale.LocaleKeys.add_vendor_flower_card_price.tr,
                                  name: locale.LocaleKeys.add_vendor_flower_card_count.tr,
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
                            child: RawAutocomplete(
                              optionsBuilder: (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  // return const Iterable<String>.empty();
                                  List<String> matches = <String>[];
                                  for(final item in controller.categoriesFromJson){
                                    matches.add(item.name);
                                  }
                                  return matches;
                                }
                                else{
                                  List<String> matches = <String>[];
                                  for(final item in controller.categoriesFromJson){
                                    matches.add(item.name);
                                  }
                                  matches.retainWhere((name){
                                    return name.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                  });
                                  return matches;
                                }
                              },

                              onSelected: (String selection) {
                                controller.categoryList.add(selection);
                                print('You just selected $selection');
                              },

                              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                                return TextField(
                                  decoration: InputDecoration(
                                    suffixIcon: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: InkWell(
                                            splashColor: const Color(0xffc4c4c4),
                                            customBorder: const CircleBorder(),
                                            onTap: () {
                                              controller.addCategory(textEditingController.text);
                                              textEditingController.clear();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal:8),
                                              child: Container(
                                                  width: 65,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: const Color(0xff050a0a)),
                                                      color: const Color(0xffc4c4c4)
                                                  ),
                                                  child: Obx(() => (controller.isLoadingCategory.value) ? const Center(
                                                    child: SizedBox(
                                                        width: 15,
                                                        height: 15,
                                                        child: CircularProgressIndicator()
                                                    ),
                                                  ) : const Icon(Icons.add,size:25))
                                              ),
                                            )
                                        )
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
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  onSubmitted: (String value) {
                                  },
                                );
                              },

                              optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
                                  Iterable<String> options) {
                                return Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(right:60),
                                  child: Material(
                                      child:SingleChildScrollView(
                                          child: Column(
                                            children: options.map((opt){
                                              return InkWell(
                                                  onTap: (){
                                                    onSelected(opt);
                                                  },
                                                  child:Card(
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.all(10),
                                                        child:Text(opt),
                                                      )
                                                  )
                                              );
                                            }).toList(),
                                          )
                                      )
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Obx(() => (controller.categoryList.isNotEmpty) ?
                        Padding(
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
                                ),)
                          ),
                        ) : const SizedBox(height: 0)),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ElevatedButton(
                            onPressed: ()=>{
                              _colorPickerDialog(context)
                            },
                            child: Obx(() => (controller.isLoadingColor.value) ? const Center(
                              child: SizedBox(
                                  width: 50,
                                  child: LinearProgressIndicator()
                              ),
                            ) :
                            Text(locale.LocaleKeys.add_vendor_flower_card_color_picker.tr)),
                          ),
                        ),
                        Obx(() => (controller.colors.isNotEmpty) ?
                        SizedBox(
                          height: controller.space.value,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.colors.length,
                              itemBuilder: (_,index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap:()=>controller.removeColor(Color(controller.colors[index])),
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Color(controller.colors[index]),
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(200),
                                      ),
                                    ),
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
                                child: Obx(() => (controller.isLoadingSubmit.value) ? const Center(
                                  child: SizedBox(
                                      width: 50,
                                      child: LinearProgressIndicator()
                                  ),
                                ): Text(locale.LocaleKeys.add_vendor_flower_card_submit.tr),)
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
                controller.addColor(controller.currentColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

  void _deleteImageDialog(BuildContext context){
    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to delete this ?"),
          actions: [
            TextButton(
                child: const Text("Cancel"),
                onPressed:  (){
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
              child: const Text("Continue"),
              onPressed:  () {
                controller.deleteImage();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showImagePicker(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Add image!",style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        // color: Color(0xff050a0a)
                      ),),
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
                        child: const Column(
                          children: [
                            Icon(Icons.image_outlined,size: 55),
                            Text("Gallery",style: TextStyle(
                                fontSize: 15
                            ),),
                          ],
                        ),
                        onTap: () {
                          controller.imageFromGallery();
                          Navigator.pop(context);
                        },
                      ),
                      InkWell(
                        child: const Column(
                          children: [
                            Icon(Icons.camera_alt_outlined,size: 55),
                            Text("Camera",style: TextStyle(
                                fontSize: 15
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50,bottom: 20,left: 15,right: 15),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

}