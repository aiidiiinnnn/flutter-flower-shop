import 'package:get/get.dart';
import '../controller/user_flower_cart_controller.dart';

class UserFlowerCartBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => UserFlowerCartController());
  }

}