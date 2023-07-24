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
import '../repositories/add_vendor_flower_repository.dart';


class AddVendorFlowerController extends GetxController{
  final AddVendorFlowerRepository _repository = AddVendorFlowerRepository();
  final GlobalKey<FormState> formKey=GlobalKey();
  final GlobalKey<FormState> categoryKey=GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  LoginVendorViewModel? vendor;
  RxBool isLoading=true.obs;
  RxBool isRetry=false.obs;
  RxList categoryList=[].obs;
  List<dynamic> colors=[];
  RxList colorList=[].obs;
  RxString imagePath=''.obs;
  RxString savedImage=''.obs;
  int? vendorId;
  RxDouble space=RxDouble(30);
  RxList<CategoriesViewModel> categoriesFromJson=RxList();


  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedVendor().then((id) => vendorId=id);
    await getVendorById();
    await getCategories();
  }

  Future<int?> sharedVendor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("vendorId");
  }

  Future<void> addCategory(String category) async {
    if (!categoryKey.currentState!.validate()) {
      return;
    }
    final categoryDto = CategoriesDto(name: category);
    final Either<String, CategoriesViewModel> categoryRequest = await _repository.addCategories(categoryDto);
    categoryRequest.fold(
            (left) => print(left),
            (right) => {
          Get.snackbar('Category', 'category successfully added'),
          categoryList.add(category),
          categoryController.clear(),
        });
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
    for(final cat in categoryList){
      if(category==cat){
        return "Category has already add";
      }
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
            (left) => print(left),
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

}