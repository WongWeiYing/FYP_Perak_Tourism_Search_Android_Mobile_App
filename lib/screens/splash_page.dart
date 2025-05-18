import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/utils/state_provider.dart/postcode_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/generated/assets.gen.dart';

final animationProvider = StateProvider<bool>((ref) => false);

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnimated = ref.watch(animationProvider);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1600),
    );

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(animationProvider.notifier).state = true;
        animationController.forward();

        Future.delayed(const Duration(milliseconds: 2000), () async {
          await ref.read(postcodeProvider.notifier).initFromJson();
          Navigator.pushReplacementNamed(context, CustomRouter.login);
        });
      });
      return null;
    }, [animationController]);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: isAnimated ? 0 : -30,
              left: isAnimated ? 0 : -30,
              child: Image.asset(
                Assets.images.splashShape.path,
                width: 150.w,
                height: 150.h,
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: isAnimated ? 150 : -80,
              left: isAnimated ? 30 : -10,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1600),
                opacity: isAnimated ? 1 : 0,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Go Perak',
                      style: TextStyle(
                        color: AppColor.mainBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Discover the beauty and uniqueness \nOf Perak, Malaysia",
                      style: TextStyle(
                        color: AppColor.mainBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: isAnimated ? 220 : -30,
              left: isAnimated ? 20 : -20,
              right: isAnimated ? 20 : -20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1600),
                opacity: isAnimated ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    Assets.images.bwSplash.path,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              bottom: isAnimated ? 50 : -10,
              right: isAnimated ? 20 : -20,
              child: Container(
                width: 40,
                height: 30,
                color: AppColor.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
