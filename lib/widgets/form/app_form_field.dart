import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/widgets/form/app_base_form_field.dart';
import 'package:go_perak/widgets/form/app_form_state.dart';

class AppTextFormField extends BaseFormField {
  /// Provide formKey for auto-validate all filled with button
  final GlobalKey<AppFormState>? formKey;
  final double? height;
  final EdgeInsets? padding;
  final Widget? suffix;
  final Widget? prefix;
  final int? maxline;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Alignment alignment;
  final BoxShadow? boxShadow;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final TextEditingController? controller;
  final bool isObscure;
  final int? maxLength;
  final bool readOnly;
  final int? minLine;
  final FocusNode? focusNode;
  final Future<String?>? Function()? onTap;
  final Icon? prefixIcon;
  final Icon? suffixIcon;

  const AppTextFormField(
      {super.key,
      required super.label,
      required super.fieldKey,
      super.isRequired,
      super.validator,
      super.initialValue,
      super.hint,
      super.onChanged,
      super.isEnabled,
      this.maxline,
      this.height,
      this.prefix,
      this.suffix,
      this.floatingLabelBehavior,
      this.padding,
      this.boxShadow,
      this.formKey,
      this.textInputAction = TextInputAction.done,
      this.inputFormatters,
      this.keyboardType,
      this.alignment = Alignment.center,
      this.decoration,
      this.textStyle,
      this.controller,
      this.isObscure = false,
      this.maxLength,
      this.readOnly = false,
      this.minLine,
      this.focusNode,
      this.onTap,
      this.prefixIcon,
      this.suffixIcon});

  @override
  State<StatefulWidget> createState() => AppTextFormFieldState();
}

class AppTextFormFieldState extends BaseFormFieldState<AppTextFormField> {
  late TextEditingController tec;
  late FocusNode focusNode;

  String get text => tec.text;

  bool get hasValue => text.isNotEmpty;

  @override
  void initState() {
    assert(!(widget.controller != null && widget.initialValue.isNotEmpty),
        'Cannot provide both controller and initialValue');
    tec = widget.controller ?? TextEditingController(text: widget.initialValue);
    focusNode = widget.focusNode ?? FocusNode();

    tec.addListener(() {
      setState(() {
        errorMsg = '';
      });
      widget.formKey?.currentState?.validateFormButton();
      widget.onChanged?.call(text);
    });
    super.initState();
  }

  @override
  bool validate() {
    if (!widget.isEnabled) {
      return true;
    }

    if (widget.isRequired) {
      setState(() {
        if (widget.validator != null) {
          errorMsg = widget.validator?.call(text) ?? '';
        } else if (text.isEmpty) {
          errorMsg = '${widget.label} is required';
        } else {
          setState(() {
            errorMsg = '';
          });
        }
      });
    } else {
      setState(() {
        errorMsg = '';
      });
    }

    return errorMsg.isEmpty;
  }

  @override
  String onSaved() {
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: widget.height,
          child: Align(
            alignment: widget.alignment,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              textBaseline: TextBaseline.alphabetic,
              children: [
                widget.prefix ?? const SizedBox(),
                Expanded(
                  child: TextFormField(
                    minLines: widget.minLine ?? 1,
                    maxLength: widget.maxLength,
                    magnifierConfiguration: TextMagnifierConfiguration.disabled,
                    onTap: () async {
                      if (widget.onTap != null) {
                        final value = await widget.onTap?.call() ?? '';
                        if (value.isEmpty) {
                          return;
                        }

                        tec.text = value;
                      }
                    },
                    controller: tec,
                    focusNode: focusNode,
                    enabled: widget.isEnabled,
                    textInputAction: widget.textInputAction,
                    inputFormatters: widget.inputFormatters,
                    keyboardType: widget.keyboardType,
                    style: widget.textStyle ?? BaseFormField.textStyle,
                    // widget.isEnabled
                    //     ? widget.textStyle ?? BaseFormField.textStyle
                    //     : BaseFormField.textStyle.copyWith(
                    //         color: AppColor.offWhite.withOpacity(0.3),
                    //       ),
                    decoration: widget.decoration ??
                        BaseFormField.inputDecoration.copyWith(
                          contentPadding: const EdgeInsets.all(4),
                          labelText: widget.label,
                          hintText: widget.hint,
                          floatingLabelBehavior: widget.floatingLabelBehavior,
                          suffix: widget.suffix,
                          prefix: widget.prefix,
                          prefixIcon: widget.prefixIcon,
                          suffixIcon: widget.suffixIcon,
                          enabledBorder: widget.isEnabled
                              ? BaseFormField.inputDecoration.enabledBorder
                              : OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.r)),
                                  borderSide: BorderSide(
                                    color: AppColor.labelGray.withOpacity(0.2),
                                  ),
                                ),
                          focusedBorder: widget.isEnabled
                              ? BaseFormField.inputDecoration.focusedBorder
                              : OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.r)),
                                  borderSide: BorderSide(
                                    color: AppColor.labelGray.withOpacity(0.2),
                                  ),
                                ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.r)),
                            borderSide: BorderSide(
                              color: AppColor.labelGray.withOpacity(0.2),
                            ),
                          ),
                        ),
                    maxLines: widget.maxline ?? 1,
                    obscureText: widget.isObscure,
                    readOnly: widget.onTap != null || widget.readOnly,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: errorMsg.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(errorMsg, style: BaseFormField.formErrorStyle),
          ),
        ),
      ],
    );
  }
}
