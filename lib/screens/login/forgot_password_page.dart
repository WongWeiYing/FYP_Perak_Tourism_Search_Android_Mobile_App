import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_background.dart';
import 'package:go_perak/constants/app_enum.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/repositories/auth.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:go_perak/widgets/form/app__form_key.dart';
import 'package:go_perak/widgets/form/app_form_field.dart';
import 'package:go_perak/widgets/form/app_form_state.dart';

class ForgotPasswordPage extends HookWidget {
  ForgotPasswordPage({super.key});

  final formKey = GlobalKey<AppFormState>();

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Colors.white,
      ),
      backgroundType: BackgroundType.withoutScroll,
      child: AppForm(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapHeight24,
            Text(
              'Enter your email to reset password',
              style: AppTextStyle.header3,
            ),
            gapHeight8,
            const AppTextFormField(
              label: 'Email',
              fieldKey: AppFormFieldKey.emailKey,
              prefixIcon: Icon(Icons.email),
            ),
            gapHeight4,
            Text(
              'We will send you a message to set or reset your new password',
              style: AppTextStyle.description,
            ),
            gapHeight16,
            PrimaryButton(
                title: 'Send Link',
                onTap: () async {
                  await formKey.currentState!.validate(
                      onSuccess: (formData) async {
                    await sendPasswordResetEmail(formData['email'], context);
                    Navigator.pop(context);
                  });
                }),
          ],
        ),
      ),
    );
  }
}
