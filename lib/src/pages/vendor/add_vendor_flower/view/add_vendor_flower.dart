import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'widget/custom_add_form_field.dart';
import '../controller/add_vendor_flower_controller.dart';
class AddVendorFlower extends  GetView<AddVendorFlowerController>{
  const AddVendorFlower({super.key});



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xfff3f7f7),
            appBar: AppBar(
              backgroundColor: const Color(0xfff3f7f7),
              title: const Text("Add Vendor Flower",style: TextStyle(
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
                width: 350,
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
                                  hintText: "Name",
                                  name: "Name",
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
                                  hintText: "Price",
                                  name: "Price",
                                  controller: controller.priceController,
                                  validator: controller.priceValidator,
                                  icon: Icons.attach_money_outlined,
                                ),
                                CustomAddFormField(
                                  hintText: "Count",
                                  name: "Count",
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
                                      borderSide: BorderSide(color: Color(0xff050a0a))
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff050a0a))
                                  ),
                                  labelText: "Category",
                                  labelStyle: const TextStyle(color: Color(0xff050a0a)),
                                ),
                                validator: controller.categoryValidator,
                                controller: controller.categoryController,
                              ),
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 25, minHeight: 0),
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
                                  itemCount: controller.colorList.length,
                                  itemBuilder: (_,index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: controller.colorList[index],
                                          border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                      )
                                  )
                              ),)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff6cba00),
                              ),
                              onPressed: ()=>controller.addVendorFlower(),
                              child: const Text('Submit'),
                            ),
                          ),
                        ),
                    ]
                  )
        ),
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