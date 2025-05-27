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
