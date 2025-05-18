import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_text_style.dart';

class AppSearchBar extends HookWidget {
  final TextEditingController controller;
  final EdgeInsets? padding;
  final Color? fillColor;
  final TextStyle? style;

  const AppSearchBar(
      {super.key,
      required this.controller,
      this.padding,
      this.fillColor,
      this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width) * 0.75,
      decoration: BoxDecoration(
        color: AppColor.labelGray.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.labelGray.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(4, 12),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        enableSuggestions: false,
        autocorrect: false,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? AppColor.white,
          suffixIcon: const Icon(Icons.search),
          prefixIconConstraints: BoxConstraints(maxHeight: 24.h),
          hintText: 'Search',
          labelStyle: AppTextStyle.bodyText.copyWith(color: AppColor.offWhite),
          hintStyle: AppTextStyle.bodyText.copyWith(color: AppColor.labelGray),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 255, 255),
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: const BorderSide(
              color: AppColor.white,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: const BorderSide(
              color: AppColor.white,
              width: 1.0,
            ),
          ),
        ),
        style:
            style ?? AppTextStyle.bodyText.copyWith(color: AppColor.labelGray),
      ),
    );
  }
}
