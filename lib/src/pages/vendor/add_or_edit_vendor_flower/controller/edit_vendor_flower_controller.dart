import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taav_ui/taav_ui.dart';

import '../../../login_page/models/vendor_models/login_vendor_view_model.dart';
import '../models/addOrEdit_vendor/addOrEdit_vendor_flower_view_model.dart';
import '../models/addOrEdit_vendor/edit_vendor_flower_dto.dart';
import '../models/categories/categories_dto.dart';
import '../models/categories/categories_view_model.dart';
import '../models/colors/color_dto.dart';
import '../models/colors/colors_view_model.dart';
import 'base_vendor_flower_controller.dart';

class EditVendorFlowerController extends BaseVendorFlowerController {
  int? _selectedFlowerId;

  void editColor(Color color) {
    pickerColor = color;
  }

  String? categoryValidator(final String? category) {
    if (category == null || category.isEmpty) {
      return "Please enter the category";
    }
    return null;
  }

  Future<void> getFlowerById() async {
    final Either<String, AddOrEditVendorFlowerViewModel> flowerById =
    await repository.getFlowerById(_selectedFlowerId!);
    flowerById.fold((left) {
      Get.snackbar(left, left);
    }, (right) {
      nameController.text = right.name;
      descriptionController.text = right.description;
      priceController.text = "${right.price}";
      countController.text = "${right.count}";
      categoryList.value = right.category;
      savedImage.value = right.imageAddress;
      colors.value = right.color;
    });
  }

  EditVendorFlowerDto _generateDto() =>
      EditVendorFlowerDto(
        name: nameController.text,
        description: descriptionController.text,
        imageAddress: savedImage.value,
        price: int.parse(priceController.text),
        color: colors,
        category: categoryList,
        count: int.parse(countController.text),
        id: _selectedFlowerId!,
        vendorName: vendor!.firstName,
        vendorLastName: vendor!.lastName,
        vendorImage: vendor!.imagePath,
      );

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedVendor().then((id) => vendorId = id);
    _selectedFlowerId = Get.arguments['id'];
    nameController.text = Get.arguments['name'];
    descriptionController.text = Get.arguments['description'];
    priceController.text = "${Get.arguments['price']}";
    countController.text = "${Get.arguments['count']}";
    categoryList.value = Get.arguments['category'];
    savedImage.value = Get.arguments['imageAddress'];
    colors.value = Get.arguments['color'];
    await getVendorById();
    await getFlowerById();
    await getCategories();
    await getColors();
  }

  @override
  Future<void> modify() async {
    if (formKey.currentState!.validate()) {
      isLoadingSubmit.value = true;
      final EditVendorFlowerDto dataTransferObject = _generateDto();
      final result = await repository.editFlower(
          flowerDto: dataTransferObject);
      if (result.isLeft) {
        isLoadingSubmit.value = false;
        Get.snackbar('Error', result.left);
      } else {
        isLoadingSubmit.value = false;
        Get.back(result: result.right);
      }
    }
  }
}
