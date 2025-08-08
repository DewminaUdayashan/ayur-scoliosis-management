import 'package:flutter/material.dart';

extension SnackExtension on BuildContext {
  void showSuccess(String message) {
    // Show a snack bar with the provided message
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void showError(String message) {
    // Show a snack bar with the provided message
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
