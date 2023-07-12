import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/login_page/models/vendor_models/login_vendor_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/repositories/vendor_flower_list_repository.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/screens/vendor_flower_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../flower_shop.dart';
import '../models/vendor_flower_dto.dart';
import '../view/screens/vendor_flower_home.dart';


class VendorFlowerListController extends GetxController{
  LoginVendorViewModel? vendor;
  int? vendorId;
  RxBool isChecked = false.obs;
  final VendorFlowerListRepository _repository = VendorFlowerListRepository();
  RxList<VendorFlowerViewModel> vendorFlowersList =RxList();
  RxBool isLoading=true.obs;
  RxBool isRetry=false.obs;
  RxBool textFlag = true.obs;
  RxInt index=RxInt(0);

  void onDestinationSelected(index){
    this.index.value=index;
  }

  final screens = [
    const VendorFlowerHome(),
    const Center(child: Text('History',style: TextStyle(fontSize: 72),)),
    const Center(child: Text('Search',style: TextStyle(fontSize: 72),)),
    const VendorFlowerProfile(),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedVendor().then((id) => vendorId=id);
    await getVendorById();
    await getFlowersByVendorId();
  }

  Future<int?> sharedVendor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("vendorId");
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAndToNamed(RouteNames.loginPage);
  }

  Future<void> goToAdd() async {
    final result = await Get.toNamed("${RouteNames.vendorFlowerList}${RouteNames.vendorFlowerHome}${RouteNames.addVendorFlower}");
    if (result != null) {
      final VendorFlowerViewModel newVendorFlower = VendorFlowerViewModel
          .fromJson(result);
      vendorFlowersList.add(newVendorFlower);
    }
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

  Future<void> getFlowersByVendorId() async{
    vendorFlowersList.clear();
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<VendorFlowerViewModel>> flower = await _repository.getFlowerByVendorId(vendorId!);
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
          vendorFlowersList.addAll(right);
          isLoading.value=false;
        }
    );
  }

  Future<void> addFlowerCount({required VendorFlowerViewModel flowerToEdit, required int index}) async {
    if (flowerToEdit.count >= 0){
      final result = await _repository.editFlowerCount(
        dto: _generatePlusDto(flowerToEdit),
        flowerId: flowerToEdit.id,
      );

      result.fold((exception) {
        Get.snackbar('Exception', exception);
      }, (auctionId) {
        addCount(index: index);
      });
    }
  }

  VendorFlowerDto _generatePlusDto(VendorFlowerViewModel flowerViewModel) => VendorFlowerDto(
    name: flowerViewModel.name,
    description: flowerViewModel.description,
    imageAddress: flowerViewModel.imageAddress,
    price: flowerViewModel.price,
    color: flowerViewModel.color,
    category: flowerViewModel.category,
    vendorId: flowerViewModel.vendorId,
    count: ++ flowerViewModel.count,
  );

  void addCount({required int index}) {
    int editedCount = vendorFlowersList[index].count;
    final editedFlower = vendorFlowersList[index].copyWith(
      count: editedCount++,
    );
    vendorFlowersList[index] = editedFlower;
  }


  Future<void> minusFlowerCount({required VendorFlowerViewModel flowerToEdit, required int index}) async {
    if (flowerToEdit.count > 0){
      final result = await _repository.editFlowerCount(
        dto: _generateMinusDto(flowerToEdit),
        flowerId: flowerToEdit.id,
      );

      result.fold((exception) {
        Get.snackbar('Exception', exception);
      }, (auctionId) {
        minusCount(index: index);
      });
    }
  }

  VendorFlowerDto _generateMinusDto(VendorFlowerViewModel flowerViewModel) => VendorFlowerDto(
    name: flowerViewModel.name,
    description: flowerViewModel.description,
    imageAddress: flowerViewModel.imageAddress,
    price: flowerViewModel.price,
    color: flowerViewModel.color,
    category: flowerViewModel.category,
    vendorId: flowerViewModel.vendorId,
    count: -- flowerViewModel.count,
  );

  void minusCount({required int index}) {
    int editedCount = vendorFlowersList[index].count;
    final editedFlower = vendorFlowersList[index].copyWith(
      count: editedCount--,
    );
    vendorFlowersList[index] = editedFlower;
  }

  Future<void> deleteFlower(VendorFlowerViewModel flower) async {
    final result = await _repository.deleteFlower(flowerId: flower.id);

    final bool isRecipeDeleted = result == null;
    if (isRecipeDeleted) {
      vendorFlowersList.remove(flower);
    }
    else {
      Get.snackbar('Error',result);
    }
  }

  Future<void> goToEdit(VendorFlowerViewModel flowerViewModel) async {
    final result = await Get.toNamed("${RouteNames.vendorFlowerList}${RouteNames.vendorFlowerHome}${RouteNames.editVendorFlower}",
      arguments: {
        'id': flowerViewModel.id,
        'name': flowerViewModel.name,
        'imageAddress': flowerViewModel.imageAddress,
        'description': flowerViewModel.description,
        "price": flowerViewModel.price,
        "color": flowerViewModel.color,
        "category": flowerViewModel.category,
        "count": flowerViewModel.count,
        "vendorId": flowerViewModel.vendorId,
      },
    );
    final bool isFlowerEdited = result != null;
    if (isFlowerEdited) {
      final int index = vendorFlowersList.indexOf(flowerViewModel);
      vendorFlowersList[index] = VendorFlowerViewModel(
          id: result['id'],
          name: result['name'],
          imageAddress: result['imageAddress'],
          description: result['description'],
          price: result['price'],
          color: result['color'],
          category: result['category'],
          vendorId: result['vendorId'],
          count: result['count']
      );
    }
  }



}