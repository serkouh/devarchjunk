import 'package:flutter/material.dart';

Color mainblue = Color(0xFF009CD1);
Color lightblue = Color(0xFF30BEE1);
Color darkgreen = Color(0xFF006400);
Color darkblue = Color(0xFF004F98);
Color mediumblue = Color(0xFF0073CF);
Color LightBlue = Color(0xFF3E8EDE);
Color green2 = Color.fromARGB(255, 6, 108, 6);
Color lightgreen = Color.fromARGB(255, 5, 135, 5);

Color green3 = Color.fromARGB(255, 42, 184, 42);
InputDecoration primaryInputDecoration({
  required String hintText,
  required IconData prefixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.grey.shade600,
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 20,
    ),
    filled: true,
    fillColor: Colors.grey.shade100,
    border: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: darkblue,
      ),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    prefixIcon: Icon(
      prefixIcon,
      size: 28,
      color: darkblue,
    ),
  );
}
