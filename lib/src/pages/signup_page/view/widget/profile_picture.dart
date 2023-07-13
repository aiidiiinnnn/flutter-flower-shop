import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/signup_page_controller.dart';

class ProfilePicture extends GetView<SignupPageController>{
  ProfilePicture({super.key, required this.shapeSize});
  double shapeSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children:[
        Container(
          width: shapeSize,
          height: shapeSize,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xff7f8283)
          ),
          child: Obx(() => controller.imagePath.isNotEmpty? CircleAvatar(backgroundImage: FileImage(File(controller.imagePath.toString())),) :
          const Icon(Icons.person,color: Color(0xfff3f7f7),size: 120),)
        ),
          Positioned(
            left: -10,
            bottom: -10,
            child: Material(
              color: const Color(0xffc4c4c4),
              borderRadius: BorderRadius.circular(200),
              child: InkWell(
                splashColor: Colors.blue,
                customBorder: const CircleBorder(),
                onTap: (){
                  _showImagePicker(context);
                },
                child: Container(
                  width: shapeSize/2.5,
                  height: shapeSize/2.5,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(200),
                  ),
                  child: Icon(Icons.add_a_photo_outlined,size: shapeSize/4.5)
                  // child:
                  )
                ),
              ),
            ),
        ]
      ),
    );
  }

  void _showImagePicker(BuildContext context){
    showBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/6.2,
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.image_outlined,size: 60),
                        Text("Gallery",style: TextStyle(
                          fontSize: 16
                        ),),
                      ],
                    ),
                    onTap: () {
                      controller.imageFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.camera_alt_outlined,size: 60),
                        Text("Camera",style: TextStyle(
                            fontSize: 16
                        ),),
                      ],
                    ),
                    onTap: () {
                      controller.imageFromCamera();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
