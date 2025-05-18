import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_text_style.dart';

class AppTextButton extends HookWidget {
  final String title;
  final TextStyle? textStyle;
  final Function onTap;
  final Color? color;

  const AppTextButton(
      {super.key,
      required this.title,
      this.textStyle,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onTap.call();
        },
        child: Center(
          child: Text(title,
              textAlign: TextAlign.center,
              style: textStyle ??
                  AppTextStyle.action
                      .copyWith(color: color ?? AppColor.primaryColor)),
        ));
  }
}
