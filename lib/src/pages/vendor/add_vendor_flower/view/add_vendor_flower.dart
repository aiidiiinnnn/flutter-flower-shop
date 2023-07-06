import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/widget/vendor_flower_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../vendor_flower_list/view/widget/custom_add_form_field.dart';
import '../controller/add_vendor_flower_controller.dart';
class AddVendorFlower extends  GetView<AddVendorFlowerController>{
  const AddVendorFlower({super.key});



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
                Form(
                    child: Column(
                      children: [
                        CustomAddFormField(
                          hintText: "Flower Name",
                          name: "Flower Name",
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
                      ],
                    )
                ),
                ElevatedButton(
                    onPressed: ()=>{
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
                                  // print(controller.currentColor);
                                  print(controller.pickerColor);
                                  print(controller.colorList);
                                  print(controller.colors);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          )
                      )
                    },
                  child: const Text("Color Picker"),
                ),
                SizedBox(
                  height: 30,
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
                )
              ],
            ),
          ),
        )
    );
  }

}