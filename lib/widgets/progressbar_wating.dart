import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Progressbar {
  static BuildContext? _context;
  static bool isDismiss = false;

  static void showProgress() {
    isDismiss = false;
    if (_context != null) {
      try {
        Navigator.pop(_context!);
      } catch (e) {}
      _context = null;
    }
    showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (c) {
          _context = c;
          if (isDismiss) {
            dismiss();
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        });
  }

  static void dismiss() {
    isDismiss = true;
    if (_context != null) {
      Navigator.pop(_context!);
      _context = null;
    }
  }
}
