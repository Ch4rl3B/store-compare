

import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension ShowError on BuildContext {
  void saveError(String error){
    Get.snackbar('Error guardando', error,
        colorText: Colors.white,
        duration: 3.seconds,
        backgroundColor: Get.theme.errorColor,
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        margin: const EdgeInsets.only(bottom: 12));
  }
}