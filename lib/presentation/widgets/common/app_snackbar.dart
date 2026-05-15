import 'package:flutter/material.dart';

class AppSnackbar {
  const AppSnackbar._();

  static void showInfo(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(context, message, action: action, duration: duration);
  }

  static void showError(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    _show(
      context,
      message,
      action: action,
      duration: duration,
      backgroundColor: colorScheme.errorContainer,
      textColor: colorScheme.onErrorContainer,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    required Duration duration,
    Color? backgroundColor,
    Color? textColor,
  }) {
    if (!context.mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          action: action,
          backgroundColor: backgroundColor,
          content: Text(
            message,
            style: textColor == null ? null : TextStyle(color: textColor),
          ),
        ),
      );
  }
}
