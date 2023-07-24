import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/signup_page_controller.dart';

class EmptyProfilePicture extends GetView<SignupPageController>{
  EmptyProfilePicture({super.key, required this.shapeSize});
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
          child: const Icon(Icons.person,color: Color(0xfff3f7f7),size: 120),),
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
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Add image!",style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        // color: Color(0xff050a0a)
                      ),),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(
                    height: 20,
                    color: Color(0xff9d9d9d),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: const Column(
                          children: [
                            Icon(Icons.image_outlined,size: 55),
                            Text("Gallery",style: TextStyle(
                                fontSize: 15
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
                            Icon(Icons.camera_alt_outlined,size: 55),
                            Text("Camera",style: TextStyle(
                                fontSize: 15
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
                Padding(
                  padding: const EdgeInsets.only(top: 50,bottom: 20,left: 15,right: 15),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}
