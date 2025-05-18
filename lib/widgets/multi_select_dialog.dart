import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class TagSelector extends StatelessWidget {
  final List<String> availableTags;
  final List<String> initialTags;
  final ValueChanged<List<String>> onConfirm;
  final String title;

  const TagSelector({
    super.key,
    required this.availableTags,
    this.initialTags = const [],
    required this.onConfirm,
    this.title = "Select Categories",
  });

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      initialValue: initialTags,
      selectedItemsTextStyle: const TextStyle(color: Colors.black),
      selectedColor: AppColor.primaryColor,
      backgroundColor: Colors.white,
      dialogHeight: 500.h,
      items: availableTags.map((tag) => MultiSelectItem(tag, tag)).toList(),
      title: Text(title),
      buttonText: const Text("Choose Tags"),
      onConfirm: onConfirm,
    );
  }
}
