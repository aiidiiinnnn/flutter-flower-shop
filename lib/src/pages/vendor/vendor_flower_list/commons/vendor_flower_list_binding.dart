import 'package:get/get.dart';
import '../controller/vendor_flower_list_controller.dart';

class VendorFlowerListBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => VendorFlowerListController());
  }

}