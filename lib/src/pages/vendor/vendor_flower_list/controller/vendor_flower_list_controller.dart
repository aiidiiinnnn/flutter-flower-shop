import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/login_page/models/vendor_models/login_vendor_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/repositories/vendor_flower_list_repository.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/screens/vendor_flower_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../flower_shop.dart';
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
    prefs.remove("role");
    prefs.remove("remember_me");
    prefs.remove("vendorId");
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
    final Either<String,List<VendorFlowerViewModel>> auctionItems = await _repository.getFlowerByVendorId(vendorId!);
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