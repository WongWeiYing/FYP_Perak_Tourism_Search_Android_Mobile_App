import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/utils/state_provider.dart/app_bottom_nav_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProjectAppBottomNav extends HookConsumerWidget {
  const ProjectAppBottomNav({super.key});

  Widget bottomNavItem(
    int index,
    String title,
    IconData icon,
  ) {
    return Consumer(builder: (context, ref, child) {
      final selectedIndex = ref.watch(bottomNavigationProvider).selectedIndex;
      final bottomNavNotifier = ref.watch(bottomNavigationProvider.notifier);

      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          bottomNavNotifier.setSelectedIndex(index);
        },
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //gapHeight8,
          Icon(
            icon,
            size: 26,
            color: selectedIndex == index
                ? AppColor.primaryColor
                : AppColor.placeHolderBlack,
          ),
          gapHeight8,
          Text(
            title,
            textAlign: TextAlign.center,
            style: selectedIndex == index
                ? AppTextStyle.label
                    .copyWith(fontSize: 8, color: AppColor.primaryColor)
                : AppTextStyle.caption
                    .copyWith(fontSize: 8, color: AppColor.placeHolderBlack),
          ),
        ]),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 8.h),
      child: Container(
        height: 55.h,
        decoration: BoxDecoration(
            color: AppColor.white, borderRadius: BorderRadius.circular(32.r)),
        child: Row(
          children: [
            Expanded(child: bottomNavItem(0, 'Home', Icons.home_outlined)),
            Expanded(
                child: bottomNavItem(1, 'Savelist', Icons.favorite_outline)),
            Expanded(child: bottomNavItem(2, 'Chats', Icons.chat_outlined)),
            Expanded(
                child: bottomNavItem(3, 'Profile', Icons.person_2_outlined)),
          ],
        ),
      ),
    );
  }
}
