import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          body: const Text("Hi"),
        )
    );
  }

}