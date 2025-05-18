import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_color.dart';

abstract class BaseFormFieldState<T extends StatefulWidget> extends State<T> {
  String errorMsg = '';

  bool get isValid => errorMsg.isEmpty;

  bool validate();

  dynamic onSaved();

  void setError(String error) {
    setState(() {
      errorMsg = error;
    });
  }
}

abstract class BaseFormField extends StatefulHookWidget {
  final String fieldKey;
  final String Function(dynamic value)? validator;
  final bool isRequired;
  final bool isEnabled;
  final String initialValue;
  final String label;
  final String? hint;
  final Function(dynamic)? onChanged;

  const BaseFormField({
    super.key,
    this.validator,
    this.hint,
    this.onChanged,
    this.isRequired = true,
    this.isEnabled = true,
    this.initialValue = '',
    required this.label,
    required this.fieldKey,
  });

  // static const height = 70.0;

  static const textStyle = TextStyle(
    fontSize: 16,
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );

  static const blackTextStyle = TextStyle(
    fontSize: 16,
    color: AppColor.mainBlack,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );

  static const labelStyle = TextStyle(
    fontSize: 12,
    color: AppColor.labelBlack,
    fontWeight: FontWeight.w300,
  );

  static const inputDecoration = InputDecoration(
      hintStyle: TextStyle(
        fontSize: 14,
        color: AppColor.labelMidGray,
      ),
      labelStyle: TextStyle(
        fontSize: 14,
        color: AppColor.labelMidGray,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: AppColor.mainBlack,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: AppColor.primaryColor,
          width: 1,
        ),
      ),
      counterText: '');

  static const blackTextInputDecoration = InputDecoration(
    hintStyle: TextStyle(
      fontSize: 14,
      color: AppColor.placeHolderBlack,
    ),
    labelStyle: TextStyle(
      fontSize: 16,
      color: AppColor.mainBlack,
      fontWeight: FontWeight.w300,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColor.lineGray,
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColor.lineGray,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColor.brightBlue,
        width: 1,
      ),
    ),
  );

  static TextStyle? get formErrorStyle => const TextStyle(
        color: AppColor.errorColor,
        fontSize: 12,
        fontWeight: FontWeight.w300,
      );
}
