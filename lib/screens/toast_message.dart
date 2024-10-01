import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';

Future<void> showToastMessage(
  BuildContext context, {
  required String title,
  required IconData icon,
  required Color iconColor,
}) async {
  DelightToastBar(
    builder: (context) {
      return ToastCard(
        leading: Icon(
          icon,
          size: 32,
          color: iconColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    },
    autoDismiss: true,
    snackbarDuration: const Duration(seconds: 3), // Adjusted duration
  ).show(context);
}
