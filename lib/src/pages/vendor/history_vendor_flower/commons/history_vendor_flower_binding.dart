import 'package:get/get.dart';
import '../controller/history_vendor_flower_controller.dart';

class HistoryVendorFlowerBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => HistoryVendorFlowerController());
  }

}