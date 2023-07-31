import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SignupPasswordFormField extends StatelessWidget {
  SignupPasswordFormField(
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
  RxBool obscureText = true.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => TextFormField(
              obscureText: obscureText.value,
              enableSuggestions: false,
              style: const TextStyle(color: Color(0xff050a0a)),
              decoration: InputDecoration(
                prefixIcon: Icon(icon),
                suffixIcon: IconButton(
                  onPressed: () => obscureText.value = !obscureText.value,
                  icon: Obx(() => obscureText.value
                      ? const Icon(Icons.remove_red_eye_outlined)
                      : const Icon(Icons.visibility_off_outlined)),
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff050a0a))),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff050a0a))),
                labelText: name,
                labelStyle: const TextStyle(color: Color(0xff050a0a)),
              ),
              validator: validator,
              controller: controller,
            )));
  }
}
