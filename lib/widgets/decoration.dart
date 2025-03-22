import 'package:flutter/material.dart';

// Function to return the input decoration for input texts
InputDecoration decorationTheme(
  String labelText,
  String hintText,
  Widget? prefixIcon,
) {
  return InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefixIcon,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
  );
}
