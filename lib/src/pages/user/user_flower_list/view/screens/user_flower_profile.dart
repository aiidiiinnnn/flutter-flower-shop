import 'dart:convert';

import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_flower_list_controller.dart';

class UserFlowerProfile extends GetView<UserFlowerListController> {
  const UserFlowerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff3f7f7),
        appBar: appBar(),
        body: Stack(alignment: Alignment.topCenter, children: [
          decorationBox(),
          Positioned(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [profileContent()],
            ),
          ),
          userImage(),
        ]),
      ),
    );
  }

  Positioned userImage() {
    return Positioned(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 290),
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xff7f8283)),
            child: controller.user!.imagePath.isNotEmpty
                ? SizedBox(
                    width: 400,
                    height: 400,
                    child: Image.memory(
                      base64Decode(controller.user!.imagePath),
                      fit: BoxFit.cover,
                    ))
                : const Icon(Icons.person, color: Colors.white, size: 120),
          ),
        ),
      ),
    );
  }

  Container profileContent() {
    return Container(
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
                children: [userFirstName(), userLastName()],
              ),
            ),
            userEmail(),
            logoutButton(),
          ],
        ),
      ),
    );
  }

  Padding logoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
          onPressed: () {
            controller.logOut();
          },
          child: Text(locale.LocaleKeys.user_Logout.tr)),
    );
  }

  Container userEmail() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffe9e9e9),
        border: Border.all(color: const Color(0xff9d9d9d)),
      ),
      child: Center(
          child: Text(
        controller.user!.email,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      )),
    );
  }

  Container userLastName() {
    return Container(
      width: 150,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffe9e9e9),
        border: Border.all(color: const Color(0xff9d9d9d)),
      ),
      child: Center(
          child: Text(
        controller.user!.lastName,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      )),
    );
  }

  Container userFirstName() {
    return Container(
      width: 150,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffe9e9e9),
        border: Border.all(color: const Color(0xff9d9d9d)),
      ),
      child: Center(
          child: Text(
        controller.user!.firstName,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      )),
    );
  }

  Container decorationBox() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
          color: Color(0xff6cba00)),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xfff3f7f7),
      title: Text(
        locale.LocaleKeys.user_profile_page.tr,
        style: const TextStyle(
            color: Color(0xff050a0a),
            fontWeight: FontWeight.w600,
            fontSize: 22),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xff050a0a),
        weight: 2,
      ),
    );
  }
}
