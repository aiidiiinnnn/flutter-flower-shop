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
          backgroundColor: const Color(0xff314657),
          appBar: AppBar(
            backgroundColor: const Color(0xffb32437),
            title: const Text("User Profile"),
          ),

          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 450,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.brown
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(200),
                              color: Colors.blueGrey
                          ),
                          child: controller.user!.imagePath.isNotEmpty? SizedBox(
                              width: 400,
                              height: 400,
                              child: Image.memory(base64Decode(controller.user!.imagePath),fit: BoxFit.cover,)) :
                          const Icon(Icons.person_outline,size: 30)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey
                          ),
                          child: Center(child: Text(controller.user!.firstName,style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                          ),)),
                        ),
                        Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey
                          ),
                          child: Center(child: Text(controller.user!.lastName,style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                          ),)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey
                    ),
                    child: Center(child: Text(controller.user!.email,style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),)),
                  )
                ],
              ),
            ),
          )

        )
    );
  }

}