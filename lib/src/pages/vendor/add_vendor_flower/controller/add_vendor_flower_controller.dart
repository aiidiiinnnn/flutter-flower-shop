import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/vendor/add_vendor_flower/models/add_vendor_flower_dto.dart';
import 'package:flower_shop/src/pages/vendor/add_vendor_flower/models/add_vendor_flower_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/add_vendor_flower_repository.dart';


class AddVendorFlowerController extends GetxController{
  final AddVendorFlowerRepository _repository = AddVendorFlowerRepository();
  final GlobalKey<FormState> formKey=GlobalKey();
  final GlobalKey<FormState> categoryKey=GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  RxList categoryList=[].obs;
  RxInt counterValue = RxInt(1);
  List<dynamic> colors=[];
  RxList colorList=[].obs;
  RxString imagePath=''.obs;
  RxString savedImage=''.obs;
  int? vendorId;

  void onIncrement(){
    if (counterValue.value >= 0){
      counterValue.value++;
      print(counterValue.value);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedVendor().then((id) => vendorId=id);
  }

  Future<int?> sharedVendor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("vendorId");
  }

  void onDecrement(){
    if (counterValue.value > 0){
      counterValue.value--;
      print(counterValue.value);
    }
  }

  void addCategory(String category){
    if (!categoryKey.currentState!.validate()) {
      return;
    }
    categoryList.add(category);
    categoryController.clear();
    print(categoryList);
  }

  Color currentColor = const Color(0xff32623a);
  Color pickerColor = const Color(0xff8c4169);

  void changeColor(Color color) {
    pickerColor = color;
    colorList.add(pickerColor);
    colors.add(pickerColor.value);
  }

  Future<void> imageFromCamera() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      imagePath.value=pickedImage.path.toString();
      File imageFile = File(imagePath.value);
      Uint8List bytes = await imageFile.readAsBytes();

      String base64String = base64.encode(bytes);
      savedImage.value= base64String;
      update();
    }
    else {
      print('No image selected.');
    }
  }

  Future<void> imageFromGallery() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      imagePath.value=pickedImage.path.toString();
      File imageFile = File(imagePath.value);
      Uint8List bytes = await imageFile.readAsBytes();

      String base64String = base64.encode(bytes);
      savedImage.value= base64String;
      update();
    }
    else {
      print('No image selected.');
    }
  }

  String? categoryValidator(final String? category){
    if(category == null || category.isEmpty){
      return "Please enter the category";
    }
    return null;
  }

  String? nameValidator(final String? name){
    if(name == null || name.isEmpty){
      return "Please enter name correctly";
    }
    return null;
  }

  String? descriptionValidator(final String? description){
    if(description == null || description.isEmpty){
      return "Please enter description correctly";
    }
    return null;
  }

  String? priceValidator(final String? basePrice){
    if(basePrice == null || basePrice.isEmpty){
      return "Please enter price correctly";
    }
    return null;
  }

  Future<void> addVendorFlower() async{
    if(!formKey.currentState!.validate()){
      return;
    }
    final dto = AddVendorFlowerDto(
        name: nameController.text,
        description: descriptionController.text,
        price: int.parse(priceController.text),
        color: colors,
        imageAddress: savedImage.value,
        count: counterValue.value,
        category: categoryList,
        vendorId: vendorId!
    );
    final Either<String, AddVendorFlowerViewModel> request = await _repository.addVendorFlower(dto);
    request.fold(
            (left) => print(left),
            (right) => Get.back(
            result: {
              "id":right.id,
              "name":right.name,
              "description":right.description,
              "price":right.price,
              "color": right.color,
              "imageAddress":right.imageAddress,
              "count":right.count,
              "category":right.category
            }
        )
    );
  }
}