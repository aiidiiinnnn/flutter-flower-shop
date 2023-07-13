import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../controller/user_flower_list_controller.dart';

class UserFlowerProfile extends  GetView<UserFlowerListController>{
  const UserFlowerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff3f7f7),
        appBar: AppBar(
          backgroundColor: const Color(0xfff3f7f7),
          title: const Text("User Profile",style: TextStyle(
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
                height:200,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
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
                        border: Border.all(color: const Color(0xff9d9d9d)),
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
                                    child: Center(child: Text(controller.user!.firstName,style: const TextStyle(
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
                                    child: Center(child: Text(controller.user!.lastName,style: const TextStyle(
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
                              child: Center(child: Text(controller.user!.email,style: const TextStyle(
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
                                  child: const Text("Logout")
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
                      child: controller.user!.imagePath.isNotEmpty? SizedBox(
                          width: 400,
                          height: 400,
                          child: Image.memory(base64Decode(controller.user!.imagePath),fit: BoxFit.cover,)) :
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