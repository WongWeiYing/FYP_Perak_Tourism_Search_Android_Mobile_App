import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:flutter/material.dart' as flutter;

class AppTextStyle {
  AppTextStyle._();

  static final bigNumber = flutter.TextStyle(
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w600,
    fontSize: 32.spMin,
  );

  // static final number = flutter.TextStyle(
  //   color: AppColor.mainBlack,
  //   fontWeight: FontWeight.w500,
  //   fontSize: 24.spMin,
  // );

  static final header1 = flutter.TextStyle(
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w600,
    fontSize: 24.spMin,
  );

  static final header2 = flutter.TextStyle(
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w600,
    fontSize: 20.spMin,
  );

  static final header3 = flutter.TextStyle(
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w600,
    fontSize: 16.spMin,
  );

  static final formText = flutter.TextStyle(
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w500,
    fontSize: 16.spMin,
  );

  static final bodyText = flutter.TextStyle(
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w300,
    fontSize: 16.spMin,
  );

  static final action = flutter.TextStyle(
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w600,
    fontSize: 14.spMin,
  );

  static final description = flutter.TextStyle(
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w300,
    fontSize: 14.spMin,
  );

  static final label = flutter.TextStyle(
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w600,
    fontSize: 12.spMin,
  );

  static final caption = flutter.TextStyle(
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w300,
    fontSize: 12.spMin,
  );

  // static final remark = flutter.TextStyle(
  //   color: AppColor.mainBlack,
  //   fontWeight: FontWeight.w300,
  //   fontSize: 10.spMin,
  // );
}
