import 'package:get/get.dart';
import '../controller/search_vendor_flower_controller.dart';


class SearchVendorFlowerBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => SearchVendorFlowerController());
  }

}