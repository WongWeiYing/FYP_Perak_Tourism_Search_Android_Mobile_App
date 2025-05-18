import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/data/tags_list.dart';
import 'package:go_perak/helper/image_picker.dart';
import 'package:go_perak/repositories/auth.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/utils/state_provider.dart/food_state.dart';
import 'package:go_perak/utils/state_provider.dart/sign_up_state.dart';
import 'package:go_perak/utils/validation.dart';
import 'package:go_perak/widgets/button/cancel_photo_button.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:go_perak/widgets/form/app__form_key.dart';
import 'package:go_perak/widgets/form/app_address_form.dart';
import 'package:go_perak/widgets/form/app_form_field.dart';
import 'package:go_perak/widgets/form/app_form_state.dart';
import 'package:go_perak/widgets/grid_view/photos_with_cancel_button_grid_view.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:go_perak/widgets/message/toast_message.dart';
import 'package:go_perak/widgets/multi_select_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MerchantDetailPage extends StatefulHookConsumerWidget {
  MerchantDetailPage({super.key});
  final formKey = GlobalKey<AppFormState>();

  @override
  ConsumerState<MerchantDetailPage> createState() => _MerchantDetailPageState();
}

class _MerchantDetailPageState extends ConsumerState<MerchantDetailPage> {
  final List<File> _photos = [];
  File? _logo;
  List<String> selectedTags = [];

  final isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, loading, _) => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              child: AppForm(
                key: widget.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapHeight36,
                    Text('Merchant Details', style: AppTextStyle.header1),
                    gapHeight24,
                    const AppTextFormField(
                      prefixIcon: Icon(Icons.person),
                      fieldKey: AppFormFieldKey.mNameKey,
                      label: 'Business Name',
                    ),
                    gapHeight16,
                    AppTextFormField(
                      label: 'Business Email',
                      fieldKey: AppFormFieldKey.mEmailKey,
                      keyboardType: TextInputType.emailAddress,
                      textStyle: AppTextStyle.bodyText,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) => validateEmail(value) ?? '',
                    ),
                    gapHeight16,
                    const AppTextFormField(
                      prefixIcon: Icon(Icons.call_outlined),
                      fieldKey: AppFormFieldKey.mContactNoKey,
                      label: 'Contact Number',
                    ),
                    gapHeight16,
                    const AppTextFormField(
                      prefixIcon: Icon(Icons.description),
                      fieldKey: AppFormFieldKey.mDescKey,
                      label: 'Description',
                      maxline: 5,
                      keyboardType: TextInputType.multiline,
                    ),
                    gapHeight16,
                    const AppTextFormField(
                      prefixIcon: Icon(Icons.access_time),
                      fieldKey: AppFormFieldKey.mOpHoursKey,
                      label: 'Operating Hours',
                      hint: 'e.g Monday - Friday 9am - 5pm',
                      maxline: 7,
                      keyboardType: TextInputType.multiline,
                    ),
                    gapHeight16,
                    AddressDetailsForm(
                        formKey: widget.formKey, isEnabled: false),
                    gapHeight16,
                    _buildTagSelector(),
                    gapHeight16,
                    _buildLogoPicker(),
                    gapHeight16,
                    _buildPhotoPicker(),
                    gapHeight24,
                    PrimaryButton(title: 'Sign Up', onTap: _submitForm),
                    gapHeight16,
                  ],
                ),
              ),
            ),
            if (loading) Positioned.fill(child: showLoading()),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    await widget.formKey.currentState!.validate(onSuccess: (formData) async {
      if (_logo == null || _photos.isEmpty) {
        final message = _logo == null && _photos.isEmpty
            ? 'Please upload your business logo and some business photos'
            : _logo == null
                ? 'Please upload your business logo'
                : 'Please upload some business photos';
        showCustomSnackBar(context, message);
        return;
      }

      if (selectedTags.isEmpty) {
        showCustomSnackBar(context,
            'Please select at least one tag that best fit your business');
        return;
      }

      ref
          .read(signUpProvider.notifier)
          .updateMerchantFormDataB(formData, _photos, _logo, selectedTags);

      isLoading.value = true;
      final result = await createUserWithEmailAndPassword(ref, context);
      isLoading.value = false;

      ref.invalidate(foodListProvider);
      ref.invalidate(activityListProvider);

      if (result.isNotEmpty) {
        showToast(result);
      } else {
        showCustomSnackBar(context, 'Account Created! Please login');
        Navigator.pushNamedAndRemoveUntil(
            context, CustomRouter.login, (route) => false);
      }
    });
  }

  Future<void> _pickLogo() async {
    final pickedImage = await pickImageFromGallery();
    if (pickedImage != null) {
      setState(() {
        _logo = pickedImage;
      });
    }
  }

  Future<void> _pickPhotos() async {
    final pickedImages = await pickMultipleImagesFromGallery();
    if (pickedImages.isNotEmpty) {
      setState(() {
        _photos.addAll(pickedImages);
      });
    }
  }

  Widget _buildTagSelector() {
    final tags = ref.read(signUpProvider).categoryType == 'Food'
        ? availableFoodTags
        : availableActivityTags;

    return TagSelector(
      availableTags: tags,
      initialTags: selectedTags,
      onConfirm: (values) => setState(() => selectedTags = values),
    );
  }

  Widget _buildLogoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload your business logo'),
        gapHeight8,
        GestureDetector(
          onTap: _pickLogo,
          child: _logo == null
              ? _emptyImageBox()
              : Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_logo!,
                          height: 120, width: 120, fit: BoxFit.cover),
                    ),
                    CancelPhotoButton(
                        onTap: () => setState(() => _logo = null)),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildPhotoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload your business photos'),
        gapHeight8,
        GestureDetector(
          onTap: _pickPhotos,
          child: _photos.isEmpty
              ? _emptyImageBox()
              : Scrollbar(
                  child: PhotosWithCancelButtonGridView(
                    photos: _photos,
                    onRemove: (index) =>
                        setState(() => _photos.removeAt(index)),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _emptyImageBox() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 215, 214, 214)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: const Center(child: Icon(Icons.add_a_photo)),
    );
  }
}
