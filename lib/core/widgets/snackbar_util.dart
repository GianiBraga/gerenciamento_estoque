import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SnackbarUtil {
  static SnackBar _build({
    required String title,
    required String message,
    required ContentType contentType,
    Duration duration = const Duration(seconds: 3),
  }) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
      duration: duration,
    );
  }

  // -------------------------------
  // Métodos fáceis para cada tipo:
  // -------------------------------

  static SnackBar success({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return _build(
      title: title,
      message: message,
      contentType: ContentType.success,
      duration: duration,
    );
  }

  static SnackBar error({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return _build(
      title: title,
      message: message,
      contentType: ContentType.failure,
      duration: duration,
    );
  }

  static SnackBar warning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return _build(
      title: title,
      message: message,
      contentType: ContentType.warning,
      duration: duration,
    );
  }

  static SnackBar info({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return _build(
      title: title,
      message: message,
      contentType: ContentType.help,
      duration: duration,
    );
  }
}
