import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/vendor/edit_vendor_flower/models/edit_vendor_flower_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../add_vendor_flower/models/categories/categories_dto.dart';
import '../../add_vendor_flower/models/categories/categories_view_model.dart';
import '../../add_vendor_flower/models/colors/color_dto.dart';
import '../../add_vendor_flower/models/colors/colors_view_model.dart';
import '../models/edit_vendor_flower_view_model.dart';
import '../repositories/edit_vendor_flower_repository.dart';

class EditVendorFlowerController extends GetxController {
  final EditVendorFlowerRepository _repository = EditVendorFlowerRepository();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> categoryKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  int? _selectedFlowerId;
  final FocusNode focusNode = FocusNode();
  RxList categoryList = [].obs;
  RxList colors = [].obs;
  RxString imagePath = ''.obs;
  RxString savedImage = ''.obs;
  int? vendorId;
  RxDouble space = RxDouble(30);
  RxList<CategoriesViewModel> categoriesFromJson = RxList();
  RxList<ColorsViewModel> colorsFromJson = RxList();
  RxBool isLoadingCategory = false.obs;
  RxBool isLoading = true.obs;
  RxBool isRetry = false.obs;
  RxBool isLoadingSubmit = false.obs;
  RxBool isLoadingColor = false.obs;

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
    await getFlowerById();
    await getCategories();
    await getColors();
  }

  void deleteImage() {
    imagePath.value = "";
    savedImage.value = "";
  }

  Future<int?> sharedVendor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("vendorId");
  }

  Future<void> getCategories() async {
    categoriesFromJson.clear();
    isLoading.value = true;
    isRetry.value = false;
    final Either<String, List<CategoriesViewModel>> flower =
        await _repository.getCategories();
    flower.fold((left) {
      print(left);
      isLoading.value = false;
      isRetry.value = true;
    }, (right) {
      categoriesFromJson.addAll(right);
      isLoading.value = false;
    });
  }

  Future<void> addCategory(String category) async {
    if (category.isEmpty) {
      Get.snackbar('Category', "Can't add empty category");
      return;
    }
    for (final categoryName in categoriesFromJson) {
      if (categoryName.name.toLowerCase().trim() ==
          category.toLowerCase().trim()) {
        categoryList.add(category);
        return;
      }
    }
    isLoadingCategory.value = true;
    final categoryDto = CategoriesDto(name: category);
    final Either<String, CategoriesViewModel> categoryRequest =
        await _repository.addCategories(categoryDto);
    categoryRequest.fold((left) {
      isLoadingCategory.value = false;
      print(left);
    }, (right) async {
      Get.snackbar('Category', 'category successfully added');
      categoryList.add(category);
      await getCategories();
      isLoadingCategory.value = false;
    });
  }

  void onSelectedCategory(String selection) {
    if (categoryList.isNotEmpty) {
      for (final categoryName in categoryList) {
        if (categoryName.toLowerCase().trim() ==
            selection.toLowerCase().trim()) {
          Get.snackbar('Category', "Can't add duplicate category");
          categoryController.clear();
          focusNode.unfocus();
          return;
        } else {
          categoryList.add(selection);
          print('You just selected $selection');
          categoryController.clear();
          focusNode.unfocus();
        }
      }
    } else {
      categoryList.add(selection);
      print('You just selected $selection');
      categoryController.clear();
      focusNode.unfocus();
    }
  }

  Future<void> getColors() async {
    colorsFromJson.clear();
    isLoading.value = true;
    isRetry.value = false;
    final Either<String, List<ColorsViewModel>> flower =
        await _repository.getColors();
    flower.fold((left) {
      print(left);
      isLoading.value = false;
      isRetry.value = true;
    }, (right) {
      colorsFromJson.addAll(right);
      isLoading.value = false;
    });
  }

  Color currentColor = const Color(0xff32623a);
  Color pickerColor = const Color(0xff8c4169);

  Future<void> addColor(Color color) async {
    for (final colorCode in colorsFromJson) {
      if (colorCode.code == color.value) {
        pickerColor = color;
        colors.add(pickerColor.value);
        return;
      }
    }
    isLoadingColor.value = true;
    final colorDto = ColorsDto(code: color.value);
    final Either<String, ColorsViewModel> categoryRequest =
        await _repository.addColors(colorDto);
    categoryRequest.fold((left) {
      print(left);
    }, (right) async {
      Get.snackbar('Color', 'Color successfully added');
      pickerColor = color;
      colors.add(pickerColor.value);
      await getColors();
    });
    isLoadingColor.value = false;
  }

  void removeColor(Color color) {
    colors.remove(pickerColor.value);
  }

  void editColor(Color color) {
    pickerColor = color;
  }

  Future<void> imageFromCamera() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      imagePath.value = pickedImage.path.toString();
      File imageFile = File(imagePath.value);
      Uint8List bytes = await imageFile.readAsBytes();

      String base64String = base64.encode(bytes);
      savedImage.value = base64String;
      update();
    } else {
      print('No image selected.');
    }
  }

  Future<void> imageFromGallery() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      imagePath.value = pickedImage.path.toString();
      File imageFile = File(imagePath.value);
      Uint8List bytes = await imageFile.readAsBytes();

      String base64String = base64.encode(bytes);
      savedImage.value = base64String;
      update();
    } else {
      print('No image selected.');
    }
  }

  String? categoryValidator(final String? category) {
    if (category == null || category.isEmpty) {
      return "Please enter the category";
    }
    return null;
  }

  String? countValidator(final String? count) {
    if (count == null || count.isEmpty) {
      return "Please enter the count";
    }
    return null;
  }

  String? nameValidator(final String? name) {
    if (name == null || name.isEmpty) {
      return "Please enter name correctly";
    }
    return null;
  }

  String? descriptionValidator(final String? description) {
    if (description == null || description.isEmpty) {
      return "Please enter description correctly";
    }
    return null;
  }

  String? priceValidator(final String? basePrice) {
    if (basePrice == null || basePrice.isEmpty) {
      return "Please enter price correctly";
    }
    return null;
  }

  Future<void> getFlowerById() async {
    final Either<String, EditVendorFlowerViewModel> flowerById =
        await _repository.getFlowerById(_selectedFlowerId!);
    flowerById.fold((left) {
      print(left);
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

  Future<void> editVendorFlower() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoadingSubmit.value = true;
    final EditVendorFlowerDto dataTransferObject = _generateDto();
    final result = await _repository.editFlower(flowerDto: dataTransferObject);
    if (result.isLeft) {
      isLoadingSubmit.value = false;
      Get.snackbar('Error', result.left);
    } else {
      isLoadingSubmit.value = false;
      Get.back(result: result.right);
    }
  }

  EditVendorFlowerDto _generateDto() => EditVendorFlowerDto(
        name: nameController.text,
        description: descriptionController.text,
        imageAddress: savedImage.value,
        price: int.parse(priceController.text),
        color: colors,
        category: categoryList,
        count: int.parse(countController.text),
        id: _selectedFlowerId!,
        vendorId: vendorId!,
      );
}
