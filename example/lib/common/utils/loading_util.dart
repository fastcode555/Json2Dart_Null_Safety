import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gesound/res/r.dart';
import 'package:lottie/lottie.dart';

class LoadingUtil {
  static void show() {
    EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
      indicator: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: 80,
          child: Lottie.asset(R.loading),
        ),
      ),
    );
    // ..customAnimation = CustomAnimation();
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}
