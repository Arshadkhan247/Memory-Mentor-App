// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget(
      {super.key,
      required this.controller,
      required this.keyboardType,
      this.onChanged,
      required this.suffixIcon,
      required this.fieldName,
      required this.obscureText});

  TextEditingController controller;
  var keyboardType;
  var onChanged;
  var suffixIcon;
  String fieldName;
  bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: const Color(0xFF6789CA),
      onChanged: onChanged,
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF6789CA),
            width: 2, // Set the border color when focused
          ),
        ),
        suffixIcon: suffixIcon,
        label: Text(
          fieldName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF345FB4),
          ),
        ),
      ),
    );
  }
}
