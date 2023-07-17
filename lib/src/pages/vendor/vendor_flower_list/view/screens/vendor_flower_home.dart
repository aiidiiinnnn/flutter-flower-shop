import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/widget/vendor_flower_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../controller/vendor_flower_list_controller.dart';

class VendorFlowerHome extends  GetView<VendorFlowerListController>{
  const VendorFlowerHome({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xfff3f7f7),
          appBar: AppBar(
            backgroundColor: const Color(0xfff3f7f7),
            title: const Text("Vendor Flower List",style: TextStyle(
                color: Color(0xff050a0a),
                fontWeight: FontWeight.w600,
                fontSize: 22
            ),),
            iconTheme: const IconThemeData(
              color: Color(0xff050a0a),
              weight: 2,
            ),
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
            backgroundColor: const Color(0xff6cba00),
            onPressed: ()=> controller.goToAdd(),
            child: const Icon(Icons.add,size: 40),
          ),

          body: Obx(() => RefreshIndicator(
            onRefresh: controller.getFlowersByVendorId,
            child: _pageContent(),
          ),),

        )
    );
  }

  Widget _pageContent() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    } else if (controller.isRetry.value) {
      return _retryButton();
    }
    return controller.vendorFlowersList.isNotEmpty ? _vendorFlower() :
    const Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home',style: TextStyle(fontSize: 72),),
            Text('There is no flower here', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300))
          ],
      ),
    );
  }

  Widget _retryButton() => Center(
    child: OutlinedButton(
        onPressed: controller.getFlowersByVendorId, child: const Icon(Icons.keyboard_return_outlined)),
  );

  Widget _vendorFlower() => Obx(() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: GridView.builder(
      itemCount: controller.vendorFlowersList.length,
      itemBuilder: (_,index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: VendorFlowerCard(
              vendorFlower: controller.vendorFlowersList[index],
              index: index
          )
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // crossAxisSpacing: 0,
      ),
    ),
  ));

}