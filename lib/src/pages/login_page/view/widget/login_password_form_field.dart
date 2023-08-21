import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:taav_ui/taav_ui.dart';

class LoginPasswordFormField extends StatelessWidget {
  LoginPasswordFormField(
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
  final RxBool obscureText = true.obs;

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
              child: Obx(() => TaavTextField.flat(
                label: 'Password',
                padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 15),
                obscureText: obscureText.value,
                suffixIcon: TaavIconButton.flat(
                  icon: !obscureText.value ? Icons.visibility : Icons.visibility_off,
                  shape: TaavWidgetShape.round,
                  padding: const EdgeInsets.all(4),
                  onTap: () => obscureText.value = !obscureText.value,
                ),
                validator: validator,
                controller: controller,
              ),)
          ),
        ),
        // child: Obx(() => TextFormField(
        //       obscureText: obscureText.value,
        //       enableSuggestions: false,
        //       style: const TextStyle(color: Color(0xff050a0a)),
        //       decoration: InputDecoration(
        //         prefixIcon: Icon(icon),
        //         suffixIcon: IconButton(
        //           onPressed: () => obscureText.value = !obscureText.value,
        //           icon: Obx(() => obscureText.value
        //               ? const Icon(Icons.remove_red_eye_outlined)
        //               : const Icon(Icons.visibility_off_outlined)),
        //         ),
        //         enabledBorder: const OutlineInputBorder(
        //             borderSide: BorderSide(color: Color(0xff050a0a))),
        //         focusedBorder: const OutlineInputBorder(
        //             borderSide: BorderSide(color: Color(0xff050a0a))),
        //         labelText: name,
        //         labelStyle: const TextStyle(color: Color(0xff050a0a)),
        //       ),
        //       validator: validator,
        //       controller: controller,
        //     ))
    );
  }
}
