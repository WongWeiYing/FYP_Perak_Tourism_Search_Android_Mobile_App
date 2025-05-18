import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/data/address.dart';
import 'package:go_perak/utils/state_provider.dart/postcode_state.dart';
import 'package:go_perak/widgets/form/app__form_key.dart';
import 'package:go_perak/widgets/form/app_base_form_field.dart';
import 'package:go_perak/widgets/form/app_form_field.dart';
import 'package:go_perak/widgets/form/app_form_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddressDetailsForm extends StatefulHookWidget {
  final GlobalKey<AppFormState> formKey;
  final String? addressLabel;
  final String? fieldKey;
  final Address? address;
  final bool isRequired;
  final bool? isEnabled;

  const AddressDetailsForm({
    super.key,
    required this.formKey,
    this.addressLabel,
    this.fieldKey = AppFormFieldKey.mAddressDetailsFormKey,
    this.address,
    this.isRequired = true,
    this.isEnabled = true,
  });

  @override
  AddressDetailsFormState createState() {
    return AddressDetailsFormState();
  }
}

class AddressDetailsFormState extends BaseFormFieldState<AddressDetailsForm> {
  late final TextEditingController addressController;
  late final TextEditingController postcodeController;
  late final TextEditingController cityController;
  late final TextEditingController stateController;
  late final TextEditingController countryController;

  @override
  void initState() {
    addressController = TextEditingController(text: widget.address?.street);
    postcodeController = TextEditingController(text: widget.address?.postCode);
    cityController = TextEditingController(text: widget.address?.city);
    stateController = TextEditingController(text: widget.address?.state);
    countryController = TextEditingController(text: widget.address?.country);

    super.initState();
  }

  @override
  Address onSaved() {
    return Address(
      street: addressController.text,
      postCode: postcodeController.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
    );
  }

  @override
  bool validate() {
    return addressController.text.isNotEmpty &&
        postcodeController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        countryController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppTextFormField(
          label: widget.addressLabel ?? 'Address',
          controller: addressController,
          fieldKey: AppFormFieldKey.addressKey,
          isRequired: widget.isRequired,
          isEnabled: true,
          onChanged: (value) {},
          formKey: widget.formKey),
      gapHeight16,
      Row(
        children: [
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              return AppTextFormField(
                maxLength: 5,
                isEnabled: true,
                formKey: widget.formKey,
                label: 'Postcode',
                isRequired: widget.isRequired,
                controller: postcodeController,
                fieldKey: AppFormFieldKey.postcodeKey,
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (postcode) {
                  if (postcode.isNotEmpty && postcode.length == 5) {
                    Map<String, String> autoPopulateResult = ref
                        .read(postcodeProvider.notifier)
                        .autoPopulateFromPostCode(postcode: postcode);
                    cityController.text = autoPopulateResult['city'] ?? '';
                    stateController.text = autoPopulateResult['state'] ?? '';
                    countryController.text =
                        autoPopulateResult['country'] ?? '';
                  } else if (postcode.isEmpty) {
                    cityController.clear();
                    stateController.clear();
                    countryController.clear();
                  }
                },
                validator: (value) {
                  if (stateController.text.isEmpty) {
                    return 'Invalid Postcode';
                  }
                  return '';
                },
              );
            }),
          ),
          gapWidth16,
          Expanded(
            child: AppTextFormField(
                formKey: widget.formKey,
                label: 'City',
                isRequired: widget.isRequired,
                controller: cityController,
                isEnabled: widget.isEnabled ?? true,
                onChanged: (_) {},
                fieldKey: AppFormFieldKey.cityKey),
          )
        ],
      ),
      gapHeight16,
      Row(children: [
        Expanded(
          child: AppTextFormField(
              formKey: widget.formKey,
              label: 'State',
              isRequired: widget.isRequired,
              isEnabled: widget.isEnabled ?? true,
              controller: stateController,
              onChanged: (_) {},
              fieldKey: AppFormFieldKey.stateKey),
        ),
        gapWidth16,
        Expanded(
          child: AppTextFormField(
              label: 'Country',
              controller: countryController,
              fieldKey: AppFormFieldKey.countryKey,
              isRequired: widget.isRequired,
              isEnabled: widget.isEnabled ?? true,
              onChanged: (value) {},
              formKey: widget.formKey),
        )
      ]),
      gapHeight16,
    ]);
  }
}
