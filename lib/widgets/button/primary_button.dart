import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_spacing.dart';

class PrimaryButton extends StatefulWidget {
  final Function()? onTap;
  final String? title;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final Widget? icon;
  final double? height;
  final double? width;
  final Color primaryColor;
  final bool isVertical;

  /// [PrimaryButton] use AppFormFieldKey.primaryButtonValidateKey as key to validate together with the AppForm state
  const PrimaryButton({
    super.key,
    this.onTap,
    this.title,
    this.titleFontSize,
    this.titleFontWeight,
    this.height,
    this.width,
    this.icon,
    this.primaryColor = AppColor.primaryColor,
    this.isVertical = false,
  });

  @override
  State<PrimaryButton> createState() => PrimaryButtonState();
}

class PrimaryButtonState extends State<PrimaryButton> {
  bool isLoading = false;
  // bool isEnabled = true;
  // bool _disabledButton = false;

  // setEnable(bool isEnabled) {
  //   setState(() {
  //     this.isEnabled = isEnabled;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.primaryColor,
        disabledBackgroundColor: AppColor.disabledBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: (widget.isVertical
            ? EdgeInsets.symmetric(horizontal: 20.r, vertical: 8.r)
            : null),
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: SizedBox(
        width: widget.width ?? 343.w,
        height: widget.height ?? 50.h,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : widget.isVertical
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) widget.icon!,
                        SizedBox(
                            height:
                                (widget.icon != null && widget.title != null)
                                    ? 8.h
                                    : 0),
                        if (widget.title != null)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: widget.icon != null ? 20.h : 0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: widget.width ?? 250.w),
                              child: Text(
                                widget.title!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: widget.titleFontSize ?? 14.spMin,
                                  fontWeight:
                                      widget.titleFontWeight ?? FontWeight.w900,
                                  color: AppColor.white,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) widget.icon!,
                      SizedBox(
                          height: (widget.icon != null && widget.title != null)
                              ? 8.h
                              : 0),
                      gapWidth8,
                      if (widget.title != null)
                        Text(widget.title!,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: widget.titleFontSize ?? 14.spMin,
                              fontWeight:
                                  widget.titleFontWeight ?? FontWeight.w600,
                              color: AppColor.white,
                            )),
                    ],
                  ),
      ),
    );
  }
}
