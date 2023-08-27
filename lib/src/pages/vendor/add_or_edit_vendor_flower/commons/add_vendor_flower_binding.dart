import 'package:get/get.dart';
import '../controller/add_vendor_flower_controller.dart';

class AddVendorFlowerBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => AddVendorFlowerController());
  }

}