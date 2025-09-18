import 'package:flutter/material.dart';

SnackBar buildRetrySnackBar({
  required String message,
  required VoidCallback onRetry,
}) {
  return SnackBar(
    content: Text(message),
    action: SnackBarAction(label: 'Retry', onPressed: onRetry),
  );
}

