import 'package:flutter/widgets.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:go_perak/widgets/form/app__form_key.dart';
import 'package:go_perak/widgets/form/app_form_field.dart';

class AppForm extends StatefulWidget {
  final Widget child;

  const AppForm({super.key, required this.child});

  @override
  State<AppForm> createState() => AppFormState();
}

class AppFormState extends State<AppForm> {
  Map<String, dynamic> formData = {};

  Future<void> validate({
    required Function(Map<String, dynamic> formData) onSuccess,
    Function(BuildContext firstErrorContext)? onFailed,
  }) async {
    BuildContext? firstErrorContext;
    bool isValid = true;
    context.visitChildElements((parent) {
      _visit(parent, onError: (context) {
        isValid = false;

        firstErrorContext ??= context;
      });
    });

    if (isValid) {
      await onSuccess(formData);
    } else {
      onFailed?.call(firstErrorContext!) ??
          Scrollable.ensureVisible(
            firstErrorContext!,
            duration: const Duration(milliseconds: 300),
            alignment: 0.5,
          );
    }
  }

  void setError(String passwordKey,
      {required String fieldKey, String? errorMsg}) {
    context.visitChildElements((parent) {
      _setError(parent, fieldKey: fieldKey, errorMsg: errorMsg);
    });
  }

  void validateFormButton() {
    // bool isAllFilled = true;
    // context.visitChildElements((parent) {
    //   _visit(parent, onError: (_) {
    //     isAllFilled = false;
    //   }, validateButton: true);
    // });

    // context.visitChildElements((parent) {
    //   _validateButton(parent, isAllFilled);
    // });
  }

  /// Visit each of the children of the parent element
  /// [validateButton]
  void _visit(
    Element parent, {
    required Function(BuildContext context) onError,
    bool validateButton = false,
  }) {
    parent.visitChildren((element) async {
      if (element.widget is AppTextFormField) {
        final state =
            (element as StatefulElement).state as AppTextFormFieldState;

        if (state.widget.isRequired) {
          if (validateButton) {
            final isValid = state.hasValue;
            if (!isValid) {
              onError(context);
            }
          } else {
            final isValid = state.validate();
            if (!isValid) {
              onError(state.context);
            } else {
              formData[state.widget.fieldKey] = state.onSaved();
            }
          }
        } else {
          formData[state.widget.fieldKey] = state.onSaved();
        }
      }
      // else if (element.widget is AppDropdown) {
      //   final state = (element as StatefulElement).state as AppDropdownState;

      //   if (validateButton) {
      //     if (!state.validate()) {
      //       onError(context);
      //     }
      //   } else {
      //     final isValid = state.validate();

      //     if (!isValid) {
      //       onError(state.context);
      //     } else {
      //       formData[state.widget.fieldKey] = state.onSaved();
      //     }
      //   }
      // } else if (element.widget is AppCheckbox) {
      //   final state = (element as StatefulElement).state as AppCheckboxState;

      //   if (validateButton) {
      //     if (!state.validate()) {
      //       onError(context);
      //     }
      //   } else {
      //     final isValid = state.validate();

      //     if (!isValid) {
      //       onError(state.context);
      //     } else {
      //       formData[state.widget.fieldKey] = state.onSaved();
      //     }
      //   }
      // } else if (element.widget is AddressDetailsForm) {
      //   final state =
      //       (element as StatefulElement).state as AddressDetailsFormState;

      //   if (validateButton) {
      //     if (!state.validate()) {
      //       onError(context);
      //     }
      //   } else {
      //     bool isValid = true;

      //     _visit(element, onError: (context) {
      //       onError(context);
      //       isValid = false;
      //     });

      //     if (isValid) {
      //       if (state.widget.fieldKey != null) {
      //         formData[state.widget.fieldKey!] = state.onSaved();
      //       } else {
      //         formData[AppFormFieldKey.addressDetailsFormKey] = state.onSaved();
      //       }
      //     }
      //   }
      // } else if (element.widget is AppMobileFormField) {
      //   final state =
      //       (element as StatefulElement).state as AppMobileFormFieldState;

      //   if (validateButton) {
      //     if (!state.validate()) {
      //       onError(context);
      //     }
      //   } else {
      //     bool isValid = true;

      //     _visit(element, onError: (context) {
      //       onError(context);
      //       isValid = false;
      //     });

      //     if (isValid) {
      //       formData[AppFormFieldKey.countryCodeKey] =
      //           state.onSaved().countryCode;
      //       formData[AppFormFieldKey.mobileNumberKey] =
      //           state.onSaved().mobileNumber;
      //     }
      //   }
      // } else if (element.widget is AppDocumentImageFormField) {
      //   final state = (element as StatefulElement).state
      //       as AppDocumentImageFormFieldState;

      //   if (validateButton) {
      //     state.validateImage();

      //     if (((element.widget as AppDocumentImageFormField).frontImage ==
      //             null) ||
      //         ((element.widget as AppDocumentImageFormField).backImage ==
      //             null)) {
      //       onError(context);
      //     }
      //   } else {
      //     final isValid = state.validateImage();

      //     if (!isValid) {
      //       onError(state.context);
      //     } else {
      //       formData[AppFormFieldKey.documentFrontImageKey] =
      //           state.onSaved().frontImage;
      //       formData[AppFormFieldKey.documentBackImageKey] =
      //           state.onSaved().backImage;
      //     }
      //   }
      // } else if (element.widget is AppUploadDocumentWidget) {
      //   final state =
      //       (element as StatefulElement).state as AppUploadDocumentWidgetState;

      //   if (validateButton) {
      //     state.validate();

      //     if (!state.validate()) {
      //       onError(context);
      //     }
      //   } else {
      //     bool isValid = state.validate();

      //     if (isValid) {
      //       formData[AppFormFieldKey.proofDocKey] = state.onSaved();
      //     } else {
      //       onError(state.context);
      //     }
      //   }
      // } else if (element.widget is SignAuthoriesWidget) {
      //   final state = (element as StatefulElement).state as SignWidgetState;

      //   if (validateButton) {
      //     if (!state.validate()) {
      //       onError(context);
      //     }
      //   } else {
      //     final isValid = state.validate();

      //     if (!isValid) {
      //       onError(state.context);
      //     } else {
      //       formData[state.widget.fieldKey] = await state.onSaved();
      //     }
      //   }
      // } else if (element.widget is SignatureContainer) {
      //   final state =
      //       (element as StatefulElement).state as SignatureContainerState;

      //   if (!validateButton) {
      //     if (state.widget.signatureController.isEmpty) {
      //       onError(state.context);
      //     } else {
      //       formData[state.widget.key.toString()] =
      //           state.widget.signatureController.value.isNotEmpty;
      //     }
      //   }
      //}
      else {
        _visit(element, onError: onError, validateButton: validateButton);
      }
    });
  }

  void _setError(Element parent, {required String fieldKey, String? errorMsg}) {
    parent.visitChildren((element) {
      if (element.widget is AppTextFormField) {
        final state =
            (element as StatefulElement).state as AppTextFormFieldState;
        if (state.widget.fieldKey == fieldKey) {
          state.setError(errorMsg ?? 'Invalid Value');
        }
      }
      // else if (element.widget is AppDocumentImageFormField) {
      //   final state = (element as StatefulElement).state
      //       as AppDocumentImageFormFieldState;
      //   if (state.widget.fieldKey == fieldKey) {
      //     state.setError(true);
      //   }
      // } else if (element.widget is AppUploadDocumentWidget) {
      //   final state =
      //       (element as StatefulElement).state as AppUploadDocumentWidgetState;
      //   if (state.widget.fieldKey == fieldKey) {
      //     state.setError(errorMsg ?? 'Invalid Value');
      //   }
      // }
      else {
        _setError(element, fieldKey: fieldKey, errorMsg: errorMsg);
      }
    });
  }

  void _validateButton(Element parent, bool isEnabled) {
    parent.visitChildren((element) {
      if (element.widget is PrimaryButton &&
          element.widget.key ==
              const Key(AppFormFieldKey.primaryButtonValidateKey)) {
        // final state = (element as StatefulElement).state as PrimaryButtonState;
        // state.setEnable(isEnabled);
      } else {
        _validateButton(element, isEnabled);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
