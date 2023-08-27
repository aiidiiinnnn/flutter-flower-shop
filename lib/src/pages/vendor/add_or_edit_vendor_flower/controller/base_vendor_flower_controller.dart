import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taav_ui/taav_ui.dart';

import '../../../login_page/models/vendor_models/login_vendor_view_model.dart';
import '../models/categories/categories_dto.dart';
import '../models/categories/categories_view_model.dart';
import '../models/colors/color_dto.dart';
import '../models/colors/colors_view_model.dart';
import '../repositories/addOrEdit_vendor_flower_repository.dart';

abstract class BaseVendorFlowerController extends GetxController {
  final AddOrEditVendorFlowerRepository repository = AddOrEditVendorFlowerRepository();
  final GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<FormState> categoryKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TaavSuggestionsBoxController autoCompleteController = TaavSuggestionsBoxController();
  final FocusNode focusNode = FocusNode();
  final TextEditingController countController = TextEditingController();
  LoginVendorViewModel? vendor;
  RxBool isLoading = true.obs;
  RxBool isLoadingSubmit = false.obs;
  RxBool isRetry = false.obs;
  RxBool isLoadingCategory = false.obs;
  RxBool isLoadingColor = false.obs;
  RxList categoryList = RxList();
  RxList colors = [].obs;
  RxList colorList = [].obs;
  RxString imagePath = ''.obs;
  RxString savedImage = ''.obs;
  int? vendorId;
  RxDouble space = RxDouble(30);
  RxList<CategoriesViewModel> categoriesFromJson = RxList();
  RxList<ColorsViewModel> colorsFromJson = RxList();
  RxInt countNumber = RxInt(1);
  Timer? deBouncer;
  final RxInt countValue = RxInt(0);
  Color currentColor = const Color(0xff32623a);
  Color pickerColor = const Color(0xff8c4169);

  Future<int?> sharedVendor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("vendorId");
  }

  void addCountValue(int newValue) {
    if (countValue.value == newValue) {
      return;
    }
    countValue.value = newValue;
  }

  void onSelectedCategory(String selection) {
    if (categoryList.isNotEmpty) {
      for (final categoryName in categoryList) {
        if (categoryName.toLowerCase().trim() ==
            selection.toLowerCase().trim()) {
          TaavToastManager().showToast("Can't add duplicate category", status: TaavWidgetStatus.warning);
          categoryController.clear();
          focusNode.unfocus();
          return;
        } else {
          categoryList.add(selection);
          categoryController.clear();
          focusNode.unfocus();
        }
      }
    } else {
      categoryList.add(selection);
      categoryController.clear();
      focusNode.unfocus();
    }
  }

  Future<void> addCategory(String category) async {
    if (category.isEmpty) {
      TaavToastManager().showToast("Can't add empty category", status: TaavWidgetStatus.warning);
      return;
    }
    for (final categoryName in categoryList) {
      if (categoryName.toLowerCase().trim() == category.toLowerCase().trim()) {
        TaavToastManager().showToast("Can't add duplicate category", status: TaavWidgetStatus.warning);
        return;
      }
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
    await repository.addCategories(categoryDto);
    categoryRequest.fold((left) {
      isLoadingCategory.value = false;
      Get.snackbar(left, left);
    }, (right) async {
      TaavToastManager().showToast('category successfully added', status: TaavWidgetStatus.success);
      await getCategories();
      isLoadingCategory.value = false;
      categoryList.add(category);
    });
  }

  void changeColor(Color color) {
    pickerColor = color;
    colorList.add(pickerColor);
    colors.add(pickerColor.value);
  }

  Future<void> addColor(Color color) async {
    for (final colorCode in colorsFromJson) {
      if (colorCode.code == color.value) {
        pickerColor = color;
        colorList.add(pickerColor);
        colors.add(pickerColor.value);
        return;
      }
    }
    isLoadingColor.value = true;
    final colorDto = ColorsDto(code: color.value);
    final Either<String, ColorsViewModel> categoryRequest =
    await repository.addColors(colorDto);
    categoryRequest.fold((left) {
      Get.snackbar(left, left);
    }, (right) async {
      TaavToastManager().showToast('Color successfully added', status: TaavWidgetStatus.success);
      pickerColor = color;
      colorList.add(pickerColor);
      colors.add(pickerColor.value);
      await getColors();
    });
    isLoadingColor.value = false;
  }

  void removeColor(Color color) {
    colorList.remove(pickerColor);
    colors.remove(pickerColor.value);
  }


  final RxList<Uint8List> _bytes = RxList();
  RxBool loadingForNonEditor=false.obs;

  Future<void> imageFromCamera(BuildContext context) async {
    loadingForNonEditor.value = true;
    TaavImagePicker(context).fromCamera().then((final value) async {
      _bytes
        ..clear()
        ..add(await value!.readAsBytes());
      update();
    }).catchError((final dynamic error, final StackTrace? stack) {
      if (error is TaavFilePickerException) {
        TaavToastManager()
            .showToast(error.message, status: TaavWidgetStatus.warning);
      }
    }).whenComplete(() {
      loadingForNonEditor.value = false;
    });
      // TaavImagePicker(context).fromGallerySingle().then((final value) async {
      //   final Uint8List byte = await value!.readAsBytes();
      // });

    // final XFile? pickedImage =
    // await ImagePicker().pickImage(source: ImageSource.camera);
    //
    // if (pickedImage != null) {
    //   imagePath.value = pickedImage.path.toString();
    //   File imageFile = File(imagePath.value);
    //   Uint8List bytes = await imageFile.readAsBytes();
    //
    //   String base64String = base64.encode(bytes);
    //   savedImage.value = base64String;
    //   update();
    // }
  }

  void deleteImage() {
    imagePath.value = "";
    savedImage.value = "";
  }

  Future<void> imageFromGallery(BuildContext context) async {
    loadingForNonEditor.value = true;
    TaavImagePicker(context).fromGallerySingle().then((final value) async {
      _bytes
        ..clear()
        ..add(await value!.readAsBytes());
      update();
    }).catchError((final dynamic error, final StackTrace? stack) {
      if (error is TaavFilePickerException) {
        TaavToastManager()
            .showToast(error.message, status: TaavWidgetStatus.warning);
      }
    }).whenComplete(() {
      savedImage.value = base64.encode(_bytes.first);
      loadingForNonEditor.value = false;
    });
    // final XFile? pickedImage =
    // await ImagePicker().pickImage(source: ImageSource.gallery);
    //
    // if (pickedImage != null) {
    //   imagePath.value = pickedImage.path.toString();
    //   File imageFile = File(imagePath.value);
    //   Uint8List bytes = await imageFile.readAsBytes();
    //
    //   String base64String = base64.encode(bytes);
    //   savedImage.value = base64String;
    //   update();
    // }
  }

  String? countValidator(final String? count) {
    if (count == null || count.isEmpty) {
      return "Please enter the count";
    } else if (!RegExp(r"^[1-9]\d*$").hasMatch(count)) {
      return "Enter a valid count";
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
    } else if (!RegExp(r"^[1-9]\d*$").hasMatch(basePrice)) {
      return "Enter a valid price";
    }
    return null;
  }

  Future<void> getVendorById() async {
    isLoading.value = true;
    isRetry.value = false;
    final Either<String, LoginVendorViewModel> vendorById =
    await repository.getVendor(vendorId!);
    vendorById.fold((left) {
      Get.snackbar(left, left);
      isLoading.value = false;
      isRetry.value = true;
    }, (vendorViewModel) {
      vendor = vendorViewModel;
      isLoading.value = false;
    });
  }

  Future<void> getCategories() async {
    categoriesFromJson.clear();
    isLoading.value = true;
    isRetry.value = false;
    final Either<String, List<CategoriesViewModel>> flower =
    await repository.getCategories();
    flower.fold((left) {
      Get.snackbar(left, left);
      isLoading.value = false;
      isRetry.value = true;
    }, (right) {
      categoriesFromJson.addAll(right);
      isLoading.value = false;
    });
  }

  FutureOr<List<CategoriesViewModel>> autoCompleteCategories(final String filter) async {
    categoriesFromJson.clear();
    isLoading.value = true;
    isRetry.value = false;
    if(filter.trim().isNotEmpty){
      final Either<String, List<CategoriesViewModel>> flower =
      await repository.getCategoriesAutoComplete(filter);
      return flower.fold((left) {
        Get.snackbar(left, left);
        isLoading.value = false;
        isRetry.value = true;
        return [];
      }, (right) {
        categoriesFromJson.addAll(right);
        isLoading.value = false;
        return categoriesFromJson.toList();
      });
    }
    return [];
  }

  Future<void> getColors() async {
    colorsFromJson.clear();
    isLoading.value = true;
    isRetry.value = false;
    final Either<String, List<ColorsViewModel>> flower =
    await repository.getColors();
    flower.fold((left) {
      Get.snackbar(left, left);
      isLoading.value = false;
      isRetry.value = true;
    }, (right) {
      colorsFromJson.addAll(right);
      isLoading.value = false;
    });
  }


  Future<void> modify();
}
