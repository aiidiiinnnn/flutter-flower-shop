import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorFlowerListController extends GetxController{

  RxBool isChecked = false.obs;

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("role");
    Get.back();
  }

}