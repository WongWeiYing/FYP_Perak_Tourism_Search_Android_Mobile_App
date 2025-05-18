import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_border.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/generated/assets.gen.dart';
import 'package:go_perak/utils/state_provider.dart/sign_up_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectRolePage extends HookConsumerWidget {
  const SelectRolePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSelectCard(
                    color: const Color.fromARGB(255, 150, 211, 239),
                    title: 'User',
                    img: Assets.images.authHeader.path,
                    onTap: () {
                      ref.read(signUpProvider.notifier).setRole('Users');
                      Navigator.pushNamed(context, CustomRouter.disclaimer);
                    }),
                gapWidth12,
                buildSelectCard(
                    color: const Color.fromARGB(255, 150, 211, 239),
                    title: 'Merchant',
                    img: Assets.images.onBoarding2.path,
                    onTap: () {
                      ref.read(signUpProvider.notifier).setRole('Merchants');
                      Navigator.pushNamed(context, CustomRouter.disclaimer);
                    }),
              ],
            ),
            gapHeight24,
            const Text('Click to select your roles')
          ],
        ),
      ),
    );
  }
}

class buildSelectCard extends StatelessWidget {
  final String title;
  final Color? color;
  final String img;
  final VoidCallback onTap;
  const buildSelectCard(
      {super.key,
      this.color,
      required this.img,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Wrap(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color?.withOpacity(0.2),
                  borderRadius: AppBorder.cardBorder,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.labelGray.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(4, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset(img),
                    Text(title),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
