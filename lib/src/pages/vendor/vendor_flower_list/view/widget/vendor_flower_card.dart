import 'package:flower_shop/src/pages/vendor/vendor_flower_list/controller/vendor_flower_list_controller.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class VendorFlowerCard extends GetView<VendorFlowerListController>{
  VendorFlowerCard({super.key, required this.vendorFlower, required this.index});
  VendorFlowerViewModel vendorFlower;
  int index;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.65,
      child: Container(
        width: 300,
        height: 350,
        decoration: BoxDecoration(
            color: const Color(0xff2a3945),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            const AspectRatio(
                aspectRatio: 2.2,
              child: Image(
                image: AssetImage('assets/flower.jpg', package: "flower_shop"),
                fit: BoxFit.cover,
                height: 70,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(vendorFlower.name,style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),),

                Text("\$${vendorFlower.price}",style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300
                ))
              ],
            ),
            Text(vendorFlower.description),

          ],
        ),
      ),
    );
  }
}