import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/signup_page_controller.dart';

class ImageProfilePicture extends GetView<SignupPageController> {
  const ImageProfilePicture({super.key, required this.shapeSize});
  final double shapeSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          image(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              editImage(context),
              deleteImage(context),
            ],
          )
        ],
      ),
    );
  }

  Padding deleteImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
          splashColor: Colors.blue,
          customBorder: const CircleBorder(),
          onTap: () {
            _deleteImageDialog(context);
          },
          child: Container(
              width: shapeSize / 1.5,
              height: shapeSize / 4,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color(0xffc4c4c4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Remove Image",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ))),
    );
  }

  Padding editImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
          splashColor: Colors.blue,
          customBorder: const CircleBorder(),
          onTap: () {
            _showImagePicker(context);
          },
          child: Container(
              width: shapeSize / 1.5,
              height: shapeSize / 4,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color(0xffc4c4c4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.add_a_photo_outlined, size: shapeSize / 5))),
    );
  }

  Container image() {
    return Container(
        width: shapeSize,
        height: shapeSize,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color(0xff7f8283)),
        child: CircleAvatar(
          backgroundImage: FileImage(File(controller.imagePath.toString())),
        ));
  }

  void _showImagePicker(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Add image!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              // color: Color(0xff050a0a)
                            ),
                          ),
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
                                Icon(Icons.image_outlined, size: 55),
                                Text(
                                  "Gallery",
                                  style: TextStyle(fontSize: 15),
                                ),
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
                                Icon(Icons.camera_alt_outlined, size: 55),
                                Text(
                                  "Camera",
                                  style: TextStyle(fontSize: 15),
                                ),
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
                      padding: const EdgeInsets.only(
                          top: 50, bottom: 20, left: 15, right: 15),
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
            ));
  }

  void _deleteImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to delete this ?"),
          actions: [
            TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: const Text("Continue"),
              onPressed: () {
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
