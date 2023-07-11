import 'package:get/get.dart';
import '../controller/edit_vendor_flower_controller.dart';

class EditVendorFlowerBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => EditVendorFlowerController());
  }

}