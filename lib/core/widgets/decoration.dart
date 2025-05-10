import 'package:flutter/material.dart';

InputDecoration decorationTheme(
  String labelText,
  String hintText,
  Widget? prefixIcon,
) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    labelText: labelText,
    labelStyle: const TextStyle(
      fontSize: 12, // Tamanho do label
      color: Colors.grey, // Pode ajustar a cor também, se quiser
    ),
    hintText: hintText,
    hintStyle: const TextStyle(
      fontSize: 12, // Tamanho do hint text
      color: Colors.grey, // Cor do hint text
    ),
    prefixIcon: prefixIcon,
    isDense: true, // Deixa mais compacto
    contentPadding: const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 8,
    ), // Controla altura do campo
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Color(0xFF1C4C9C),
        width: 2,
      ),
    ),
  );
}
