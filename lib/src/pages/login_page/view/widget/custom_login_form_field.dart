import 'dart:core';

import 'package:flutter/material.dart';
import 'package:taav_ui/taav_ui.dart';

class CustomLoginFormField extends StatelessWidget {
  const CustomLoginFormField(
      {super.key,
      required this.hintText,
      required this.name,
      required this.controller,
      required this.validator,
      required this.icon});
  final String hintText;
  final String name;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
      child: TaavTextFieldTheme(
        themeData: TaavTextFieldThemeData(
          labelTextStyle: const TextStyle(color: Color(0xff050a0a)),
          iconColor: Colors.white24,
          hintTextStyle: const TextStyle(color: Color(0xff050a0a)),
          isFilled: false,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 2, color: Color(0xff050a0a)),
          ),
        ),
        child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: TaavTextField.flat(
              label: name,
              padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 15),
              validator: validator,
              controller: controller,
            ),
        ),
      ),
    );
  }
}
