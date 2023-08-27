import 'dart:convert';

import 'package:flower_shop/generated/locales.g.dart' as locale;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_ui/taav_ui.dart';

import '../../controller/vendor_flower_list_controller.dart';

class VendorFlowerProfile extends GetView<VendorFlowerListController> {
  const VendorFlowerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TaavScaffold(
        showBorder: false,
        padding:  EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        backgroundColor: const Color(0xfff3f7f7),
        appBar: appBar(),
        body: Column(
          children: [
            Expanded(
              child: Stack(alignment: Alignment.topCenter, children: [
                greenDecoration(),
                Positioned(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [profileInformation()],
                  ),
                ),
                Positioned(
                  child: profilePicture(),
                ),
              ]),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TaavLabeledDivider(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: TaavText.caption1('Rate Us'),
                ),
                thickness: 1.2,
                startFlex: 1,
                endFlex: 10,
                color: TaavColors.blue,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TaavRatingBar(
                initialRating: 3,
                itemCount: 5,
                itemBuilder: (final context, final index) {
                  switch (index) {
                    case 0:
                      return const Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      );
                    case 1:
                      return const Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.redAccent,
                      );
                    case 2:
                      return const Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    case 3:
                      return const Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                      );
                  }

                  return const Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.green,
                  );
                },
                onRatingUpdate: print,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container profileInformation() {
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
                children: [profileName(), profileLastName()],
              ),
            ),
            profileEmail(),
            logoutButton(),
          ],
        ),
      ),
    );
  }

  Container profileLastName() {
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
        controller.vendor!.lastName,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      )),
    );
  }

  Container profileName() {
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
        controller.vendor!.firstName,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      )),
    );
  }

  Container profileEmail() {
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
        controller.vendor!.email,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      )),
    );
  }

  Padding logoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
          onPressed: () {
            controller.logOut();
          },
          child: Text(locale.LocaleKeys.vendor_logout.tr)),
    );
  }

  Padding profilePicture() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 290),
          height: 150,
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xff7f8283)),
          child: controller.vendor!.imagePath.isNotEmpty
              ? SizedBox(
                  width: 400,
                  height: 400,
                  child: Image.memory(
                    base64Decode(controller.vendor!.imagePath),
                    fit: BoxFit.cover,
                  ))
              : const Icon(Icons.person, color: Colors.white, size: 120),
        ),
      ),
    );
  }

  Container greenDecoration() {
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
        locale.LocaleKeys.vendor_profile_page.tr,
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
