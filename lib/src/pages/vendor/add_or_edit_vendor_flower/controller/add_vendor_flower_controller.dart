import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/login_page/models/vendor_models/login_vendor_dto.dart';

import 'package:get/get.dart';

import '../models/addOrEdit_vendor/addOrEdit_vendor_flower_view_model.dart';
import '../models/addOrEdit_vendor/add_vendor_flower_dto.dart';

import 'base_vendor_flower_controller.dart';

class AddVendorFlowerController extends BaseVendorFlowerController {

  @override
  Future<void> onInit() async {
    super.onInit();
    countController.text = countNumber.value.toString();
    await sharedVendor().then((id) => vendorId = id);
    await getVendorById();
    await getCategories();
    await getColors();
  }

  @override
  Future<void> modify() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoadingSubmit.value = true;
    final dto = AddVendorFlowerDto(
      name: nameController.text,
      description: descriptionController.text,
      imageAddress: savedImage.value,
      price: int.parse(priceController.text),
      color: colors,
      category: categoryList,
      count: int.parse(countController.text),
      vendorName: vendor!.firstName,
      vendorLastName: vendor!.lastName,
      vendorImage: vendor!.imagePath,
    );
    final Either<String, AddOrEditVendorFlowerViewModel> request =
    await repository.addVendorFlower(dto);
    request.fold((left) {
      Get.snackbar(left, left);
      isLoadingSubmit.value = false;
    }, (right) async {
      vendor!.vendorFlowerList.add(right.id);
      final result = await repository.vendorEditFlowerList(
        dto: LoginVendorDto(
            firstName: vendor!.firstName,
            lastName: vendor!.lastName,
            email: vendor!.email,
            password: vendor!.password,
            imagePath: vendor!.imagePath,
            vendorFlowerList: vendor!.vendorFlowerList),
        id: vendorId!,
      );

      result.fold((exception) {
        Get.snackbar('Exception', exception);
      }, (userId) {
        isLoadingSubmit.value = false;
        Get.back(result: {
          "id": right.id,
          "name": right.name,
          "description": right.description,
          "price": right.price,
          "color": right.color,
          "imageAddress": right.imageAddress,
          "count": right.count,
          "category": right.category,
          "vendorName": right.vendorName,
          "vendorLastName": right.vendorLastName,
          "vendorImage": right.vendorImage
        });
      });
    });
  }


}
