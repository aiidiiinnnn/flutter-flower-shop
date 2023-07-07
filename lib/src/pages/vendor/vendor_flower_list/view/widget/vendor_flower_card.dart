import 'package:flower_shop/src/pages/vendor/vendor_flower_list/controller/vendor_flower_list_controller.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class VendorFlowerCard extends GetView<VendorFlowerListController>{
  VendorFlowerCard({super.key, required this.vendorFlower, required this.index});
  VendorFlowerViewModel vendorFlower;
  int index;
  String firstHalfText="";
  String secondHalfText="";


  @override
  Widget build(BuildContext context) {
    if (vendorFlower.description.length > 28) {
      firstHalfText= vendorFlower.description .substring(0, 28);
      secondHalfText = vendorFlower.description .substring(28, vendorFlower.description .length);
    }
    else {
      firstHalfText = vendorFlower.description ;
      secondHalfText = "";
    }
    return AspectRatio(
      aspectRatio: 1.65,
      child: Container(
        width: 400,
        height: 450,
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
                height: 30,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: secondHalfText.isEmpty
                  ? Text(firstHalfText,style: const TextStyle(
                fontSize: 11
              ),)
                  : Column(
                children: [
                  Text(controller.textFlag.value ? ("$firstHalfText...") : (firstHalfText+secondHalfText),style: const TextStyle(
                    fontSize: 11
                  ),),

                  InkWell(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:[
                        Text(
                          "show more",
                          style: TextStyle(color: Colors.blue, fontSize: 11),
                        ),
                      ],
                    ),
                    onTap: () {
                      _showDescription(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDescription(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('${vendorFlower.name} description'),
          content: SingleChildScrollView(
            child: Text(firstHalfText+secondHalfText,style: const TextStyle(
                fontSize: 12
            ),),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Show less'),
              onPressed: () {
                controller.textFlag.value= !controller.textFlag.value;
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }
}