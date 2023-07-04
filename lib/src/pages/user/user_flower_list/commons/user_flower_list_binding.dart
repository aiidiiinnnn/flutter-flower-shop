import 'package:get/get.dart';
import '../controller/user_flower_list_controller.dart';

class UserFlowerListBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => UserFlowerListController());
  }

}