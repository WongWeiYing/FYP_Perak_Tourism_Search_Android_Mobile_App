import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_text_style.dart';

class CategoryChip extends StatefulWidget {
  final String? title;
  bool isSelected;

  CategoryChip({super.key, this.title, this.isSelected = false});

  @override
  State<CategoryChip> createState() => CategoryChipState();
}

class CategoryChipState extends State<CategoryChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
        decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColor.primaryColor
                : AppColor.primaryColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12.r)),
        child: Center(
          child: Text(
            widget.title ?? '',
            style: AppTextStyle.action.copyWith(color: AppColor.white),
          ),
        ));
  }
}
