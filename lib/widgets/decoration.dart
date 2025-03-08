import 'package:flutter/material.dart';

InputDecoration decoration_theme(String labelText, String hintText) {
  return InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
    labelText: labelText,
    hintText: hintText,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
  );
}
