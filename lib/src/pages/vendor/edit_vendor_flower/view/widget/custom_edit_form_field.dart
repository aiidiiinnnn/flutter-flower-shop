import 'package:flutter/material.dart';
import 'dart:core';

class CustomEditFormField extends StatelessWidget {
  const CustomEditFormField({super.key, required this.hintText,required this.name, required this.controller, required this.validator,required this.icon});
  final String hintText;
  final String name;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final IconData icon;


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          enableSuggestions: false,
          style: const TextStyle(color: Color(0xff050a0a)),
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff050a0a))
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff050a0a))
            ),
            labelText: name,
            labelStyle: const TextStyle(color: Color(0xff050a0a)),
          ),
          validator: validator,
          controller: controller,
        )
    );
  }
}