import 'package:flutter/material.dart';

/// Returns a reusable input decoration with rounded borders and customized styling.
/// Used for consistent appearance across TextFormFields in the app.
InputDecoration decorationTheme(
  String labelText, // Field label (e.g., "Name")
  String hintText, // Field hint (e.g., "Enter your name")
  Widget? prefixIcon, // Optional icon before the text input
) {
  return InputDecoration(
    // Default border with circular radius
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
    ),

    // Floating label configuration
    labelText: labelText,
    labelStyle: const TextStyle(
      fontSize: 12,
      color: Colors.grey,
    ),

    // Hint text shown inside the field
    hintText: hintText,
    hintStyle: const TextStyle(
      fontSize: 12,
      color: Colors.grey,
    ),

    // Optional icon displayed before the text
    prefixIcon: prefixIcon,

    // Compact vertical spacing
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 8,
    ),

    // Border style when field is focused
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Color(0xFF1C4C9C),
        width: 2,
      ),
    ),
  );
}
