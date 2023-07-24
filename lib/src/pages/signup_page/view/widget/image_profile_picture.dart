import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/signup_page_controller.dart';

class ImageProfilePicture extends GetView<SignupPageController>{
  ImageProfilePicture({super.key, required this.shapeSize});
  double shapeSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: ()=>_deleteImageDialog(context),
        child: Container(
            width: shapeSize,
            height: shapeSize,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xff7f8283)
            ),
            child: CircleAvatar(backgroundImage: FileImage(File(controller.imagePath.toString())),)
        ),
      ),
    );
  }

  void _deleteImageDialog(BuildContext context){
    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to delete this ?"),
          actions: [
            TextButton(
                child: const Text("Cancel"),
                onPressed:  (){
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
              child: const Text("Continue"),
              onPressed:  () {
                controller.deleteImage();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

