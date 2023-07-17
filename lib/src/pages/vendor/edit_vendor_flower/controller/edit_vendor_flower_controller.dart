import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/vendor/edit_vendor_flower/models/edit_vendor_flower_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/edit_vendor_flower_view_model.dart';
import '../repositories/edit_vendor_flower_repository.dart';

class EditVendorFlowerController extends GetxController{
  final EditVendorFlowerRepository _repository = EditVendorFlowerRepository();
  final GlobalKey<FormState> formKey=GlobalKey();
  final GlobalKey<FormState> categoryKey=GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  int? _selectedFlowerId;
  RxList categoryList=[].obs;
  RxList colors=[].obs;
  RxList colorList=[].obs;
  RxString imagePath=''.obs;
  RxString savedImage=''.obs;
  int? vendorId;
  RxDouble space=RxDouble(30);

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedVendor().then((id) => vendorId=id);
    _selectedFlowerId = Get.arguments['id'];
    nameController.text= Get.arguments['name'];
    descriptionController.text=Get.arguments['description'];
    priceController.text="${Get.arguments['price']}";
    countController.text="${Get.arguments['count']}";
    categoryList.value=Get.arguments['category'];
    savedImage.value=Get.arguments['imageAddress'];
    colors.value=Get.arguments['color'];
    getFlowerById();
  }

  Future<int?> sharedVendor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("vendorId");
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
    colors.add(pickerColor.value);
  }

  void editColor(Color color){
    pickerColor = color;
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

  String? countValidator(final String? count){
    if(count == null || count.isEmpty){
      return "Please enter the count";
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

  Future<void> getFlowerById () async{
    final Either<String, EditVendorFlowerViewModel> flowerById = await _repository.getFlowerById(_selectedFlowerId!);
    flowerById.fold(
            (left) {
              print(left);
        },
            (right) {
              nameController.text= right.name;
              descriptionController.text=right.description;
              priceController.text= "${right.price}";
              countController.text="${right.count}";
              categoryList.value= right.category;
              savedImage.value=right.imageAddress;
              colors.value=right.color;
        }
    );
  }

  Future<void> editVendorFlower() async {
    if(!formKey.currentState!.validate()){
      return;
    }
    final EditVendorFlowerDto dataTransferObject = _generateDto();
    final result = await _repository.editFlower( flowerDto:dataTransferObject);
    if(result.isLeft){
      Get.snackbar('Error', result.left);
    }else {
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