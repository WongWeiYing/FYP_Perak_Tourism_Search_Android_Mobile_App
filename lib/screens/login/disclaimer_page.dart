import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_background.dart';
import 'package:go_perak/constants/app_border.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_enum.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/widgets/bar/app_bar.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class DisclaimerPage extends HookConsumerWidget {
  const DisclaimerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBackground(
      backgroundType: BackgroundType.withoutScroll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gapHeight32,
          const ProjectAppBar(
            title: 'Identity Verification',
            showLeading: false,
          ),
          gapHeight24,
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: AppBorder.cardBorder,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.labelGray.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(4, 12),
                  ),
                ],
              ),
              width: (MediaQuery.of(context).size.width) * 0.75,
              child:
                  Lottie.asset('assets/animations/disclaimer_animation.json'),
            ),
          ),
          gapHeight24,
          Center(
            child: Text(
              'Why we need your IC?',
              style: AppTextStyle.action,
            ),
          ),
          gapHeight12,
          Center(
            child: Text(
              'To ensure the authenticity of reviews and prevent fraud or scams, '
              'we require identity verification. Your information will be handled with strict privacy standards.',
              style: AppTextStyle.caption,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          PrimaryButton(
            title: 'Continue',
            onTap: () {
              Navigator.pushNamed(context, CustomRouter.scanIc);
            },
          )
        ],
      ),
    );
  }
}
