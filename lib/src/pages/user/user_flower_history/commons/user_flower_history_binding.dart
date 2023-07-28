import 'package:get/get.dart';
import '../controller/user_flower_history_controller.dart';

class UserFlowerHistoryBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => UserFlowerHistoryController());
  }

}