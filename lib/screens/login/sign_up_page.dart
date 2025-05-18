import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/repositories/auth.dart';
import 'package:go_perak/utils/state_provider.dart/sign_up_state.dart';
import 'package:go_perak/utils/validation.dart';
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

class SignUpPage extends StatefulHookConsumerWidget {
  final String? name;
  final String? icNo;

  SignUpPage({super.key, this.name, this.icNo});
  final formKey = GlobalKey<AppFormState>();

  @override
  ConsumerState<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController icNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final List<String> _categories = ['Food', 'Activities'];

  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final bool isUser = ref.read(signUpProvider).roles == 'Users';
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fullnameController.text = widget.name ?? 'Test Merchant 3';
        usernameController.text = widget.name ?? 'Test User';
        icNoController.text = widget.icNo ?? '012345-67-8900';
        passwordController.text = '';
        confirmPasswordController.text = '';
      });
      return null;
    }, []);
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: AppForm(
                  key: widget.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gapHeight36,
                      Text('Sign Up', style: AppTextStyle.header1),
                      gapHeight24,
                      if (isUser)
                        AppTextFormField(
                          prefixIcon: const Icon(Icons.person_outline),
                          fieldKey: AppFormFieldKey.usernameKey,
                          label: 'Username',
                          controller: usernameController,
                          isEnabled: false,
                        ),
                      gapHeight16,
                      AppTextFormField(
                        prefixIcon: const Icon(Icons.person_outline),
                        fieldKey: AppFormFieldKey.fullnameKey,
                        label: 'Full Name (same as User ID)',
                        controller: fullnameController,
                        hint: 'eg. John Doe',
                        isEnabled: false,
                      ),
                      gapHeight16,
                      // if (icNoController.text.isNotEmpty)
                      AppTextFormField(
                        controller: icNoController,
                        prefixIcon: const Icon(Icons.numbers_outlined),
                        fieldKey: AppFormFieldKey.icNoKey,
                        label: 'Ic Number',
                        isEnabled: false,
                      ),

                      if (isUser) ...[
                        gapHeight16,
                        AppTextFormField(
                          label: 'Email',
                          fieldKey: AppFormFieldKey.emailKey,
                          keyboardType: TextInputType.emailAddress,
                          textStyle: AppTextStyle.bodyText,
                          prefixIcon: const Icon(Icons.email_outlined),
                          validator: (value) {
                            final result = validateEmail(value);
                            if (result != null) {
                              return result;
                            }
                            return '';
                          },
                        ),
                      ],

                      gapHeight16,
                      AppPasswordFormField(
                        formKey: widget.formKey,
                        controller: passwordController,
                        checkController: confirmPasswordController,
                      ),
                      gapHeight16,
                      AppPasswordFormField(
                        formKey: widget.formKey,
                        label: 'Confirm your password',
                        controller: confirmPasswordController,
                        checkController: passwordController,
                      ),
                      if (!isUser) ...[
                        gapHeight16,
                        DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: 'Business Category',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          value: _selectedCategory,
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                      ],
                      gapHeight24,
                      PrimaryButton(
                          title: ref.read(signUpProvider).roles == 'Users'
                              ? 'Sign Up'
                              : 'Continue',
                          onTap: () async {
                            await widget.formKey.currentState!.validate(
                                onSuccess: (formData) async {
                              if (!isUser) {
                                if (_selectedCategory == null) {
                                  showCustomSnackBar(
                                      context, 'Please your business category');
                                  return;
                                }
                              }

                              if (ref.read(signUpProvider).roles == 'Users') {
                                isLoading.value = true;
                                ref
                                    .read(signUpProvider.notifier)
                                    .updateUserFormData(formData);

                                print(
                                    "Username in state: ${ref.read(signUpProvider).username}");
                                final result =
                                    await createUserWithEmailAndPassword(
                                        ref, context);
                                isLoading.value = false;
                                if (result.isNotEmpty) {
                                  showToast(result);
                                } else {
                                  showCustomSnackBar(
                                      context, 'Account Created! Please login');
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      CustomRouter.login, (route) => false);
                                }
                              } else {
                                ref
                                    .read(signUpProvider.notifier)
                                    .updateMerchantFormDataA(
                                        formData, _selectedCategory!);

                                Navigator.pushNamed(
                                    context, CustomRouter.mMerchantDetail);
                              }
                            });
                          }),
                      gapHeight200,

                      gapHeight16
                    ],
                  )),
            ),
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
}
