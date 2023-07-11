import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import '../../add_vendor_flower/view/widget/custom_add_form_field.dart';
import '../controller/edit_vendor_flower_controller.dart';
class EditVendorFlower extends  GetView<EditVendorFlowerController>{
  const EditVendorFlower({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff314657),
          appBar: AppBar(
            backgroundColor: const Color(0xffb32437),
            title: const Text("Add Vendor Flower"),
          ),
          body: SingleChildScrollView(
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
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                          color: Colors.brown,
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
                          hintText: "Name",
                          name: "Name",
                          controller: controller.nameController,
                          validator: controller.nameValidator,
                          icon: Icons.accessibility_outlined,
                        ),
                        CustomAddFormField(
                          hintText: "Description",
                          name: "Description",
                          controller: controller.descriptionController,
                          validator: controller.descriptionValidator,
                          icon: Icons.accessibility_outlined,
                        ),
                        CustomAddFormField(
                          hintText: "Price",
                          name: "Price",
                          controller: controller.priceController,
                          validator: controller.priceValidator,
                          icon: Icons.accessibility_outlined,
                        ),
                        CustomAddFormField(
                          hintText: "Count",
                          name: "Count",
                          controller: controller.countController,
                          validator: controller.countValidator,
                          icon: Icons.accessibility_outlined,
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
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(4),
                            child: InkWell(
                                splashColor: Colors.red,
                                customBorder: const CircleBorder(),
                                onTap: ()=>controller.addCategory(controller.categoryController.text),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:8),
                                  child: Container(
                                      width: 65,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        color: Colors.red
                                        // borderRadius: BorderRadius.circular(200),
                                      ),
                                      child: const Icon(Icons.add,size:25)
                                    // child:
                                  ),
                                )
                            ),
                          ),
                          prefixIcon: const Icon(Icons.category_outlined),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          labelText: "Category",
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                        validator: controller.categoryValidator,
                        controller: controller.categoryController,
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    child: Expanded(
                      child: Obx(() => ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categoryList.length,
                        itemBuilder: (_, index) => Chip(
                          label: Text(controller.categoryList[index]),
                          onDeleted: () => {controller.categoryList.removeAt(index)},
                        ),),),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: ()=>{
                    _colorPickerDialog(context)
                  },
                  child: const Text("Color Picker"),
                ),
                SizedBox(
                  height: 25,
                  child: Expanded(
                      child: Obx(() => ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.colors.length,
                          itemBuilder: (_,index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap:() => {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Pick a color!'),
                                        content: SingleChildScrollView(
                                          child: ColorPicker(
                                            pickerColor: Color(controller.colors[index]),
                                            onColorChanged: (Color value) {
                                              controller.colors[index] = value.value;
                                            },
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text('Got it'),
                                            onPressed: () {
                                              controller.editColor(Color(controller.colors[index]));
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      )
                                  )
                                },
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
                      ),)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffb32437),
                        ),
                        onPressed: ()=>controller.editVendorFlower(),
                        child: const Text("Submit")
                    ),
                  ),
                ),
            ]
          )
        )
    )
    );
  }

  void _colorPickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Pick a color!'),
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
              child: const Text('Got it'),
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
                  child: const Column(
                    children: [
                      Icon(Icons.image_outlined,size: 60),
                      Text("Gallery",style: TextStyle(
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
                  child: const Column(
                    children: [
                      Icon(Icons.camera_alt_outlined,size: 60),
                      Text("Camera",style: TextStyle(
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