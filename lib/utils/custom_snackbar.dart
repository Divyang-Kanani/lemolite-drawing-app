import 'package:flutter/material.dart';
import 'package:lemolite_drawing/main.dart';

class CustomSnackBar {
  static void show({required String message, Color? color}) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? Colors.black,
      ),
    );
  }
}
