import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/repositories/vendor_flower_list_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../flower_shop.dart';
import '../view/screens/vendor_flower_home.dart';


class VendorFlowerListController extends GetxController{
  RxBool isChecked = false.obs;
  final VendorFlowerListRepository _repository = VendorFlowerListRepository();
  RxList<VendorFlowerViewModel> vendorFlowersList =RxList();
  RxBool isLoading=true.obs;
  RxBool isRetry=false.obs;
  RxBool textFlag = true.obs;
  RxInt index=RxInt(0);

  void onDestinationSelected(index){
    this.index.value=index;
    print(this.index);
  }

  final screens = [
    const VendorFlowerHome(),
    const Center(child: Text('History',style: TextStyle(fontSize: 72),)),
    const Center(child: Text('Search',style: TextStyle(fontSize: 72),)),
    const Center(child: Text('Profile',style: TextStyle(fontSize: 72),)),
  ];

  @override
  void onInit(){
    super.onInit();
    getVendorFlowers();
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("role");
    prefs.remove("remember_me");
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

  Future<void> getVendorFlowers() async{
    vendorFlowersList.clear();
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<VendorFlowerViewModel>> auctionItems = await _repository.getVendorFlower();
    auctionItems.fold(
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

}