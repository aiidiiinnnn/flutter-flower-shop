import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/repositories/vendor_flower_list_repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../flower_shop.dart';


class VendorFlowerListController extends GetxController{
  RxBool isChecked = false.obs;
  final VendorFlowerListRepository _repository = VendorFlowerListRepository();
  RxList<VendorFlowerViewModel> vendorFlowersList =RxList();
  RxBool isLoading=true.obs;
  RxBool isRetry=false.obs;

  @override
  void onInit(){
    super.onInit();
    getVendorFlowers();
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("role");
    Get.back();
  }

  Future<void> goToAdd() async {
    final result = await Get.toNamed("${RouteNames.loginPage}${RouteNames.vendorFlowerList}${RouteNames.addVendorFlower}");
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