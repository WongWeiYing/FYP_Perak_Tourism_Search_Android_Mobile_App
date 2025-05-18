import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/generated/assets.gen.dart';
import 'package:go_perak/screens/user/edit_info_form_page.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:go_perak/widgets/form/app__form_key.dart';
import 'package:go_perak/widgets/form/app_form_field.dart';
import 'package:go_perak/widgets/bottom_sheets/image_picker_bottom_sheet.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditUSerInfoPage extends HookConsumerWidget {
  const EditUSerInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetailsResult = ref.watch(userDetailsProvider);
    final isUploading = ref.watch(profilePicUploadingProvider);

    return userDetailsResult.when(
        loading: () => Center(child: showLoading()),
        error: (err, stack) {
          return Center(child: Text(stack.toString()));
        },
        data: (data) {
          final fullnameController = useTextEditingController();
          final usernameController = useTextEditingController();

          useEffect(() {
            fullnameController.text = data.fullname;
            usernameController.text = data.username;
            return null;
          }, [data.fullname, data.username]);
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Edit'),
                backgroundColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                await showImageSourceActionSheet(context, ref);
                              },
                              child: Stack(children: [
                                SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: data.profilePic.isEmpty
                                          ? Image.asset(
                                              Assets.images.userDefault.path,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              '${data.profilePic}', //?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                              fit: BoxFit.cover,
                                            ),
                                    )),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: AppColor.white),
                                      child: const Icon(
                                        Icons.edit,
                                        color: AppColor.black,
                                      )),
                                )
                              ]),
                            ),
                          ),
                          gapHeight32,
                          Text(
                            'Fullname',
                            style: AppTextStyle.formText,
                          ),
                          gapHeight4,
                          AppTextFormField(
                            label: '',
                            fieldKey: AppFormFieldKey.fullnameKey,
                            textStyle: AppTextStyle.bodyText,
                            prefixIcon: const Icon(Icons.person_outlined),
                            controller: fullnameController,
                            isEnabled: false,
                          ),
                          gapHeight16,
                          Text(
                            'Username',
                            style: AppTextStyle.formText,
                          ),
                          gapHeight4,
                          AppTextFormField(
                              label: '',
                              fieldKey: AppFormFieldKey.usernameKey,
                              textStyle: AppTextStyle.bodyText,
                              prefixIcon: const Icon(Icons.person_outline),
                              controller: usernameController,
                              isEnabled: true,
                              readOnly: true,
                              suffix: GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.pushNamed(
                                      context, CustomRouter.editInfoForm,
                                      arguments: EditInfoFormPage(
                                          oldData: data.username,
                                          //fieldKey: AppFormFieldKey.usernameKey,
                                          title: 'Username',
                                          collectionName: 'Users',
                                          docID: data.userID,
                                          fieldName: 'username'));

                                  if (result == true) {
                                    ref.invalidate(userDetailsProvider);
                                  }
                                },
                                child: Icon(Icons.mode_edit_outline),
                              )),
                        ],
                      ),
                    ),
                    if (isUploading)
                      Positioned.fill(
                        child: Center(
                          child: Container(
                              color: Colors.transparent, child: showLoading()),
                        ),
                      )
                  ],
                ),
              ));
        });
  }
}
