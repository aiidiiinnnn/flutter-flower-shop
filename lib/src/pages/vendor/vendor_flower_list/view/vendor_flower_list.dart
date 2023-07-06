import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/widget/vendor_flower_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../controller/vendor_flower_list_controller.dart';
class VendorFlowerList extends  GetView<VendorFlowerListController>{
  const VendorFlowerList({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff314657),
          appBar: AppBar(
            backgroundColor: const Color(0xffb32437),
            title: const Text("Vendor Flower List"),
          ),
          drawer: Drawer(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      controller.logOut();
                    },
                    child: const Text("Logout")
                ),
              ],
            ),
          ),

          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff71cc47),
            onPressed: ()=> controller.goToAdd(),
            child: const Icon(Icons.add,size: 40),
          ),

          body: Obx(() => RefreshIndicator(
            onRefresh: controller.getVendorFlowers,
            child: _pageContent(),
          ),)
        )
    );
  }

  Widget _pageContent() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    } else if (controller.isRetry.value) {
      return _retryButton();
    }
    return _vendorFlower();
  }

  Widget _retryButton() => Center(
    child: OutlinedButton(
        onPressed: controller.getVendorFlowers, child: const Icon(Icons.keyboard_return_outlined)),
  );

  Widget _vendorFlower() => GridView.builder(
      itemCount: controller.vendorFlowersList.length,
      itemBuilder: (_,index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: VendorFlowerCard(
              vendorFlower: controller.vendorFlowersList[index],
              index: index
          )
      ),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
    ),
  );

}