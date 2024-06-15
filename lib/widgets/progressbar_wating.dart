import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Progressbar {
  static BuildContext? _context;

  static void showProgress() {
    if (_context != null) {
      Navigator.pop(_context!);
    }
    showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (c) {
          _context = c;
          return Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        });
  }

  static void dismiss() {
    if (_context != null) {
      Navigator.pop(_context!);
      _context = null;
    }
  }
}
