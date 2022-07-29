import 'package:book_reader/res/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingUtil {
  static void show() {
    Get.dialog(
      Stack(
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const CupertinoActivityIndicator(color: Colors.white),
            ),
          )
        ],
      ),
      barrierDismissible: false,
      barrierColor: Colors.transparent,
    );

    // ..customAnimation = CustomAnimation();
  }

  static void dismiss() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
