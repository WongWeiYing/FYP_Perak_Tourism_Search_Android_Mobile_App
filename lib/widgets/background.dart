import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum BackgroundType { primary }

class AppBackground extends HookWidget {
  final Widget? child;
  final BackgroundType backgroundType;
  final bool showAppBar;

  const AppBackground({
    super.key,
    this.child,
    this.backgroundType = BackgroundType.primary,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (backgroundType) {
      case BackgroundType.primary:
        return SafeArea(
          child: Scaffold(
              body: SingleChildScrollView(
                  child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: child,
          ))),
        );
    }
  }
}
