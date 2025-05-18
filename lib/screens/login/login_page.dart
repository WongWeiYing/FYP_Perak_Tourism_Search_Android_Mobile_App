import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/repositories/auth.dart';
import 'package:go_perak/utils/state_provider.dart/app_bottom_nav_state.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/widgets/form/app__form_key.dart';
import 'package:go_perak/widgets/form/app_form_field.dart';
import 'package:go_perak/widgets/form/app_form_state.dart';
import 'package:go_perak/widgets/form/app_password_form_field.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:go_perak/widgets/message/toast_message.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  LoginPage({super.key});

  final formKey = GlobalKey<AppFormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Stack(
          children: [
            AppForm(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapHeight100,
                    Text('Login', style: AppTextStyle.header1),
                    gapHeight24,
                    AppTextFormField(
                      label: 'Email',
                      fieldKey: AppFormFieldKey.emailKey,
                      keyboardType: TextInputType.emailAddress,
                      textStyle: AppTextStyle.bodyText,
                      prefixIcon: const Icon(Icons.email),
                    ),
                    gapHeight16,
                    AppPasswordFormField(
                      formKey: GlobalKey<AppFormState>(),
                    ),
                    gapHeight8,
                    _buildForgotPassword(context, ref),
                    gapHeight8,
                    PrimaryButton(
                        title: 'Login',
                        onTap: () async {
                          await _submitForm(context, ref, isLoading);
                        }),
                    const Spacer(),
                    _buildSignUp(context),
                    gapHeight16
                  ],
                )),
            if (isLoading.value == true)
              Positioned.fill(
                child:
                    Container(color: Colors.transparent, child: showLoading()),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPassword(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          ref.read(bottomNavigationProvider.notifier).setSelectedIndex(0);
          Navigator.pushNamed(
            context,
            CustomRouter.dahsboard,
          );
        },
        child: Padding(
          padding: EdgeInsets.only(top: 4.h, right: 8.w, bottom: 4.w),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, CustomRouter.forgotPass);
            },
            child: Text(
              'Forgot password?',
              style: AppTextStyle.action,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Don\'t have an account? ',
          style: AppTextStyle.bodyText,
          children: [
            TextSpan(
              text: 'Sign Up',
              style: AppTextStyle.action.copyWith(color: AppColor.primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  Navigator.pushNamed(context, CustomRouter.selectRole);
                },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm(BuildContext context, WidgetRef ref,
      ValueNotifier<bool> isLoading) async {
    await formKey.currentState!.validate(onSuccess: (formData) async {
      isLoading.value = true;

      final result = await signInWithEmailAndPassword(
        (formData['email'] as String).trim(),
        (formData['password'] as String).trim(),
        context,
        ref,
      );

      isLoading.value = false;

      if (result.isEmpty) {
        final role = ref.read(currentUserProvider).role;
        final route = role == 'Users'
            ? CustomRouter.dahsboard
            : CustomRouter.merchantHome;
        Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
      } else {
        showCustomSnackBar(context, result);
      }
    });
  }
}
