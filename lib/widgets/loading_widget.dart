import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Widget showLoading() {
  return Center(
    child: Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Lottie.asset(
        'assets/animations/loading_animation.json',
        width: 200.w,
        height: 200.h,
      ),
    ),
  );
}
