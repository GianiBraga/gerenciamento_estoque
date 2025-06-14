import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

/// Utility class to generate styled snackbars using the awesome_snackbar_content package.
class SnackbarUtil {
  /// Core method for building a styled snackbar with a given type.
  static SnackBar _build({
    required String title,
    required String message,
    required ContentType contentType,
    Duration duration = const Duration(seconds: 1),
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

  // -------------------------------------------------
  // Simple factory methods for commonly used types:
  // -------------------------------------------------

  /// Displays a success snackbar.
  static SnackBar success({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 1),
  }) {
    return _build(
      title: title,
      message: message,
      contentType: ContentType.success,
      duration: duration,
    );
  }

  /// Displays an error snackbar.
  static SnackBar error({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 1),
  }) {
    return _build(
      title: title,
      message: message,
      contentType: ContentType.failure,
      duration: duration,
    );
  }

  /// Displays a warning snackbar.
  static SnackBar warning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 1),
  }) {
    return _build(
      title: title,
      message: message,
      contentType: ContentType.warning,
      duration: duration,
    );
  }

  /// Displays an informational snackbar.
  static SnackBar info({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 1),
  }) {
    return _build(
      title: title,
      message: message,
      contentType: ContentType.help,
      duration: duration,
    );
  }
}
