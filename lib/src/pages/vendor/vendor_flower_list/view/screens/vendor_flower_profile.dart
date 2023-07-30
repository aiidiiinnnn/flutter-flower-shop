import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_flower_list_controller.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

class VendorFlowerProfile extends  GetView<VendorFlowerListController>{
  const VendorFlowerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff3f7f7),
        appBar: AppBar(
          backgroundColor: const Color(0xfff3f7f7),
          title: Text(locale.LocaleKeys.vendor_profile_page.tr,style: const TextStyle(
              color: Color(0xff050a0a),
              fontWeight: FontWeight.w600,
              fontSize: 22
          ),),
          iconTheme: const IconThemeData(
            color: Color(0xff050a0a),
            weight: 2,
          ),
        ),

        body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height:250,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
                    color: Color(0xff6cba00)
                ),
              ),
              Positioned(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 160),
                      width: 350,
                      height: 300,
                      decoration: BoxDecoration(
                        color: const Color(0xffe9e9e9),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff9d9d9d).withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(4, 4), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 90),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xffe9e9e9),
                                      border: Border.all(color: const Color(0xff9d9d9d)),
                                    ),
                                    child: Center(child: Text(controller.vendor!.firstName,style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500
                                    ),)),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xffe9e9e9),
                                      border: Border.all(color: const Color(0xff9d9d9d)),
                                    ),
                                    child: Center(child: Text(controller.vendor!.lastName,style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500
                                    ),)),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 300,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xffe9e9e9),
                                border: Border.all(color: const Color(0xff9d9d9d)),
                              ),
                              child: Center(child: Text(controller.vendor!.email,style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                              ),)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    controller.logOut();
                                  },
                                  child: Text(locale.LocaleKeys.vendor_logout.tr)
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 290),
                      height:150,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color(0xff7f8283)
                      ),
                      child: controller.vendor!.imagePath.isNotEmpty? SizedBox(
                          width: 400,
                          height: 400,
                          child: Image.memory(base64Decode(controller.vendor!.imagePath),fit: BoxFit.cover,)) :
                      const Icon(Icons.person,color: Colors.white,size: 120),
                    ),
                  ),
                ),
              ),
            ]
        ),
      ),
    );

  }

}