import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../flower_shop.dart';

class UserFlowerListController extends GetxController{
  RxBool isChecked = false.obs;

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("role");
    Get.back();
  }

}