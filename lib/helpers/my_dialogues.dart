import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialogues {
  static success({required String msg}) {
    Get.snackbar(
      'Success',
      msg,
      colorText: Colors.white,
      backgroundColor: Colors.green.withValues(alpha: 0.9 * 255),
    );
  }

  static error({required String msg}) {
    Get.snackbar(
      'Error',
      msg,
      colorText: Colors.white,
      backgroundColor: Colors.redAccent.withValues(alpha: 0.9 * 255),
    );
  }

  static info({required String msg}) {
    Get.snackbar(
      'Info',
      msg,
      colorText: Colors.white,
    );
  }

  static showProgress() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      barrierDismissible: false, // Prevents dismissing by tapping outside
    );
  }
}
