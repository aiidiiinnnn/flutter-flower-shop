import 'package:get/get.dart';
import '../controller/user_flower_search_controller.dart';


class UserFlowerSearchBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => UserFlowerSearchController());
  }

}