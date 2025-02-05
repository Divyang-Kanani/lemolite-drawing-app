import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lemolite_drawing/main.dart';

class CustomProgressDialog {
  static Future<void> show() async {
    await showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: Dialog(
            shape: const CircleBorder(),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Center(
                child: Platform.isAndroid
                    ? const CircularProgressIndicator()
                    : const CupertinoActivityIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }

  static void dismiss() {
    Navigator.of(navigatorKey.currentContext!).pop();
  }
}
