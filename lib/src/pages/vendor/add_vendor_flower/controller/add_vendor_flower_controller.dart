import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/login_page/models/vendor_models/login_vendor_dto.dart';
import 'package:flower_shop/src/pages/vendor/add_vendor_flower/models/add_vendor/add_vendor_flower_view_model.dart';
import 'package:flower_shop/src/pages/vendor/add_vendor_flower/models/categories/categories_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../login_page/models/vendor_models/login_vendor_view_model.dart';
import '../models/add_vendor/add_vendor_flower_dto.dart';
import '../models/categories/categories_view_model.dart';
import '../models/colors/color_dto.dart';
import '../models/colors/colors_view_model.dart';
import '../repositories/add_vendor_flower_repository.dart';


class AddVendorFlowerController extends GetxController{
  final AddVendorFlowerRepository _repository = AddVendorFlowerRepository();
  final GlobalKey<FormState> formKey=GlobalKey();
  final GlobalKey<FormState> categoryKey=GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final Rx<TextEditingController> categoryController = Rx(TextEditingController());
  final TextEditingController countController = TextEditingController();
  LoginVendorViewModel? vendor;
  RxBool isLoading=true.obs;
  RxBool isLoadingSubmit=false.obs;
  RxBool isRetry=false.obs;
  RxBool isLoadingCategory=false.obs;
  RxBool isLoadingColor=false.obs;
  RxList categoryList=RxList();
  List colors=[];
  RxList colorList=[].obs;
  RxString imagePath=''.obs;
  RxString savedImage=''.obs;
  int? vendorId;
  RxDouble space=RxDouble(30);
  RxList<CategoriesViewModel> categoriesFromJson=RxList();
  RxList<ColorsViewModel> colorsFromJson=RxList();


  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedVendor().then((id) => vendorId=id);
    await getVendorById();
    await getCategories();
    await getColors();
  }

  Future<int?> sharedVendor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("vendorId");
  }

  Future<void> addCategory(String category) async {
    if(category.isEmpty){
      Get.snackbar('Category', "Can't add empty category");
      return;
    }
    for(final categoryName in categoriesFromJson){
      if(categoryName.name.toLowerCase().trim()==category.toLowerCase().trim()){
        categoryList.add(category);
        return;
      }
    }
    isLoadingCategory.value=true;
    final categoryDto = CategoriesDto(name: category);
    final Either<String, CategoriesViewModel> categoryRequest = await _repository.addCategories(categoryDto);
    categoryRequest.fold(
            (left) {
              isLoadingCategory.value=false;
              print(left);
            },
            (right) async {
              Get.snackbar('Category', 'category successfully added');
              categoryList.add(category);
              await getCategories();
              isLoadingCategory.value=false;
        });
  }

  Color currentColor = const Color(0xff32623a);
  Color pickerColor = const Color(0xff8c4169);

  void changeColor(Color color) {
    pickerColor = color;
    colorList.add(pickerColor);
    colors.add(pickerColor.value);
  }

  Future<void> addColor(Color color) async {
    for(final colorCode in colorsFromJson){
      if(colorCode.code==color.value){
        pickerColor = color;
        colorList.add(pickerColor);
        colors.add(pickerColor.value);
        return;
      }
    }
    isLoadingColor.value=true;
    final colorDto = ColorsDto(code: color.value);
    final Either<String, ColorsViewModel> categoryRequest = await _repository.addColors(colorDto);
    categoryRequest.fold(
            (left) {
              print(left);
        },
            (right) async {
          Get.snackbar('Color', 'Color successfully added');
          pickerColor = color;
          colorList.add(pickerColor);
          colors.add(pickerColor.value);
          await getColors();
        });
    isLoadingColor.value=false;
  }

  void removeColor(Color color) {
    colorList.remove(pickerColor);
    colors.remove(pickerColor.value);
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

  void deleteImage(){
    imagePath.value="";
    savedImage.value="";
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

  String? countValidator(final String? count){
    if(count == null || count.isEmpty){
      return "Please enter the count";
    }
    else if(!RegExp(r"^[1-9]\d*$").hasMatch(count)){
      return "Enter a valid count";
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
    else if(!RegExp(r"^[1-9]\d*$").hasMatch(basePrice)){
    return "Enter a valid price";
    }
    return null;
  }

  Future<void> getVendorById() async{
    isLoading.value=true;
    isRetry.value=false;
    final Either<String, LoginVendorViewModel> vendorById = await _repository.getVendor(vendorId!);
    vendorById.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (vendorViewModel) {
          vendor=vendorViewModel;
          isLoading.value=false;
        }
    );
  }

  Future<void> addVendorFlower() async{
    if(!formKey.currentState!.validate()){
      return;
    }
    isLoadingSubmit.value=true;
    final dto = AddVendorFlowerDto(
        name: nameController.text,
        description: descriptionController.text,
        price: int.parse(priceController.text),
        color: colors,
        imageAddress: savedImage.value,
        count: int.parse(countController.text),
        category: categoryList,
        vendorId: vendorId!
    );
    final Either<String, AddVendorFlowerViewModel> request = await _repository.addVendorFlower(dto);
    request.fold(
            (left) {
              print(left);
              isLoadingSubmit.value=false;
            },
            (right) async {
          vendor!.vendorFlowerList.add(right.id);
          final result = await _repository.vendorEditFlowerList(
            dto: LoginVendorDto(
                firstName: vendor!.firstName,
                lastName: vendor!.lastName,
                email: vendor!.email,
                password: vendor!.password,
                imagePath: vendor!.imagePath,
                vendorFlowerList: vendor!.vendorFlowerList
            ),
            id: vendorId!,
          );

          result.fold(
                  (exception) {
                Get.snackbar('Exception', exception);
              },
                  (userId) {
                    isLoadingSubmit.value=false;
                    Get.back(result: {
                      "id": right.id,
                      "name": right.name,
                      "description": right.description,
                      "price": right.price,
                      "color": right.color,
                      "imageAddress": right.imageAddress,
                      "count": right.count,
                      "category": right.category,
                      "vendorId":right.vendorId
                    });
                  });
        }
    );}

  Future<void> getCategories() async{
    categoriesFromJson.clear();
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<CategoriesViewModel>> flower = await _repository.getCategories();
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
              categoriesFromJson.addAll(right);
              isLoading.value=false;
            }
    );
  }
  Future<void> getColors() async{
    colorsFromJson.clear();
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<ColorsViewModel>> flower = await _repository.getColors();
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
              colorsFromJson.addAll(right);
              isLoading.value=false;
        }
    );
  }

}