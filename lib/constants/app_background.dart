import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_enum.dart';

class AppBackground extends HookWidget {
  final Widget? child;
  final BackgroundType backgroundType;
  final PreferredSizeWidget? appBar;
  final Future<void> Function()? onRefresh;
  final bool? showDrawer;
  final void Function(String)? onDrawerItemSelected;
  final Widget? bottomNavigationBar;

  const AppBackground({
    this.appBar,
    super.key,
    this.child,
    this.bottomNavigationBar,
    this.backgroundType = BackgroundType.primary,
    this.onRefresh,
    this.showDrawer = false,
    this.onDrawerItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    switch (backgroundType) {
      case BackgroundType.primary:
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
                child: child,
              ),
            ),
            bottomNavigationBar: bottomNavigationBar,
          ),
        );
      case BackgroundType.withoutScroll:
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar,
            extendBody: true,
            body: Container(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: child,
            ),
            bottomNavigationBar: bottomNavigationBar,
          ),
        );
    }
  }
}
