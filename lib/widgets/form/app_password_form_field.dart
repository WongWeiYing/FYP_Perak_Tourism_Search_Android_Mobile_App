import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/widgets/form/app__form_key.dart';
import 'package:go_perak/widgets/form/app_form_field.dart';
import 'package:go_perak/widgets/form/app_form_state.dart';

class AppPasswordFormField extends HookWidget {
  final String fieldKey;
  final String? label;
  final GlobalKey<AppFormState> formKey;
  final TextEditingController? controller;
  final TextEditingController? checkController;

  const AppPasswordFormField(
      {super.key,
      required this.formKey,
      this.controller,
      this.checkController,
      this.label,
      this.fieldKey = AppFormFieldKey.passwordKey});

  @override
  Widget build(BuildContext context) {
    final showPassword = useState(false);

    return AppTextFormField(
      label: label ?? 'Password',
      fieldKey: fieldKey,
      formKey: formKey,
      controller: controller,
      textStyle: AppTextStyle.formText,
      prefixIcon: const Icon(Icons.lock),
      suffix: GestureDetector(
        onTap: () {
          showPassword.value = !showPassword.value;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
              showPassword.value ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      isObscure: !showPassword.value,
      validator: (value) {
        if (checkController != null && (value != checkController?.text)) {
          return 'Password is not match';
        }
        if (value == null || value.toString().length < 6) {
          return 'Password must be at least 6 characters';
        }
        return '';
      },
    );
  }
}
