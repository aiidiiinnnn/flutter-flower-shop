import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../login_page/models/vendor_models/login_vendor_view_model.dart';
import '../models/purchase_view_model.dart';
import '../repositories/history_vendor_flower_repository.dart';

class HistoryVendorFlowerController extends GetxController {
  final HistoryVendorFlowerRepository _repository =
      HistoryVendorFlowerRepository();
  RxList<Map<dynamic, dynamic>> salesList = RxList();
  LoginVendorViewModel? vendor;
  int? vendorId;
  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;
  RxBool textFlag = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedUser().then((id) => vendorId = id);
    await getVendorById();
    await purchaseHistory();
  }

  Future<int?> sharedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("vendorId");
  }

  Future<void> getVendorById() async {
    isLoading.value = true;
    isRetry.value = false;
    final Either<String, LoginVendorViewModel> vendorById =
        await _repository.getVendor(vendorId!);
    vendorById.fold((left) {
      Get.snackbar(left, left);
      isLoading.value = false;
      isRetry.value = true;
    }, (vendorViewModel) {
      vendor = vendorViewModel;
      isLoading.value = false;
    });
  }

  Future<void> purchaseHistory() async {
    salesList.clear();
    isLoading.value = true;
    isRetry.value = false;
    final Either<String, List<PurchaseViewModel>> flower =
        await _repository.purchaseHistory();
    flower.fold((left) {
      Get.snackbar(left, left);
      isLoading.value = false;
      isRetry.value = true;
    }, (right) {
      for (final flower in right) {
        for (final purchase in flower.purchaseList) {
          if (purchase.vendorName == vendor!.firstName &&
              purchase.vendorLastName == vendor!.lastName) {
            salesList.add({
              "card": purchase,
              "date": flower.date,
              "userName": flower.userName,
              "userLastName": flower.userLastName
            });
          }
        }
      }
      isLoading.value = false;
    });
  }
}
