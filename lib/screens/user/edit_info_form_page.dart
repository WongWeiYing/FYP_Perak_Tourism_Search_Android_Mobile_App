import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/data/tags_list.dart';
import 'package:go_perak/helper/extension.dart';
import 'package:go_perak/repositories/update_repo.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:go_perak/widgets/form/app__form_key.dart';
import 'package:go_perak/widgets/form/app_address_form.dart';
import 'package:go_perak/widgets/form/app_form_field.dart';
import 'package:go_perak/widgets/form/app_form_state.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:go_perak/widgets/message/toast_message.dart';
import 'package:go_perak/widgets/multi_select_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditInfoFormPage extends HookConsumerWidget {
  final String? oldData;
  final String title;
  final String collectionName;
  final String docID;
  final String fieldName;
  final int? maxLine;
  final int option;
  final List<String>? tags;

  EditInfoFormPage({
    super.key,
    this.oldData,
    required this.title,
    required this.collectionName,
    required this.docID,
    this.maxLine = 1,
    this.option = 0,
    this.tags,
    required this.fieldName,
  });

  final formKey = GlobalKey<AppFormState>();

  final UpdateRepo updateRepo = UpdateRepo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldController = useTextEditingController(text: oldData);
    final isLoading = useState(false);
    final selectedTags = useState<List<String>>(tags ?? []);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(title),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context, false),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              AppForm(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapHeight16,
                    if (option == 0)
                      _buildTextField(fieldController)
                    else if (option == 1)
                      _buildTagSelector(selectedTags)
                    else if (option == 2)
                      AddressDetailsForm(
                        formKey: formKey,
                        address: oldData?.toAddress(),
                        isEnabled: false,
                      ),
                    gapHeight24,
                    _buildSubmitButton(
                        context, fieldController, selectedTags, isLoading),
                  ],
                ),
              ),
              if (isLoading.value)
                Positioned.fill(
                  child: Container(
                    color: Colors.transparent,
                    child: showLoading(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return AppTextFormField(
      fieldKey: AppFormFieldKey.sharedKey,
      keyboardType: maxLine != 1 ? TextInputType.multiline : TextInputType.text,
      label: '',
      isEnabled: true,
      controller: controller,
      maxline: maxLine,
    );
  }

  Widget _buildTagSelector(ValueNotifier<List<String>> selectedTags) {
    final items =
        collectionName == 'Food' ? availableFoodTags : availableActivityTags;
    return TagSelector(
      availableTags: items,
      initialTags: tags ?? [],
      onConfirm: (values) {
        selectedTags.value = values.cast<String>();
      },
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    TextEditingController controller,
    ValueNotifier<List<String>> selectedTags,
    ValueNotifier<bool> isLoading,
  ) {
    return PrimaryButton(
      title: 'Done',
      onTap: () async {
        if (option == 0) {
          _updateTextField(context, controller, isLoading);
        } else if (option == 1) {
          _updateTags(context, selectedTags, isLoading);
        } else if (option == 2) {
          _updateAddress(context, isLoading);
        }
      },
    );
  }

  Future<void> _updateTextField(BuildContext context,
      TextEditingController controller, ValueNotifier<bool> isLoading) async {
    await formKey.currentState!.validate(onSuccess: (formData) async {
      final newData = controller.text.trim();

      if (newData == oldData) {
        showCustomSnackBar(context, 'Same ${title.toLowerCase()}');
        return;
      }

      isLoading.value = true;

      if (collectionName == 'Users') {
        final isUsernameTaken = await updateRepo.checkDuplicatedInfo(
            collectionName, docID, fieldName, newData, null);

        if (isUsernameTaken) {
          isLoading.value = false;
          showCustomSnackBar(
              context, 'Username already exists. Choose another.');
          return;
        }
      }

      final result = await updateRepo.updateInfo(
          collectionName, docID, fieldName, newData, null);

      if (collectionName == 'Users') {
        print('update all ratings');
        print('$docID');
        FirebaseFirestore.instance
            .collectionGroup('Ratings')
            .where('userID', isEqualTo: docID)
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.update({'username': newData}).then((value) {
              print('Successfully updated username for ${doc.id}');
            }).catchError((error) {
              print('Error updating username: $error');
            });
          }
        });
      }

      isLoading.value = false;

      checkResult(context, result);
    });
  }

  Future<void> _updateTags(
    BuildContext context,
    ValueNotifier<List<String>> selectedTags,
    ValueNotifier<bool> isLoading,
  ) async {
    if (selectedTags.value.isEmpty) {
      showCustomSnackBar(context, 'Please select at least one tag!');
      return;
    }

    isLoading.value = true;

    final result = await updateRepo.updateInfo(
        collectionName, docID, fieldName, null, selectedTags.value);
    isLoading.value = false;
    checkResult(context, result);
  }

  Future<void> _updateAddress(
    BuildContext context,
    ValueNotifier<bool> isLoading,
  ) async {
    await formKey.currentState!.validate(onSuccess: (formData) async {
      final String address =
          '${formData['address']}, ${formData['postcode']}, ${formData['city']}, ${formData['state']}';
      isLoading.value = true;
      final result = await updateRepo.updateInfo(
          collectionName, docID, fieldName, address, null);
      isLoading.value = false;
      await checkResult(context, result);
    });
  }
}

Future<void> checkResult(BuildContext context, String result) async {
  if (result.isNotEmpty) {
    showCustomSnackBar(context, result);
    return;
  } else {
    Navigator.pop(context, true);
  }
}
