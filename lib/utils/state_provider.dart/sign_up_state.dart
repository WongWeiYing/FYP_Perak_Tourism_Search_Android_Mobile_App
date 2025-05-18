import 'dart:io';

import 'package:go_perak/data/sign_up_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final signUpProvider = StateNotifierProvider<SignUpState, SignUpData>((ref) {
  return SignUpState();
});

class SignUpState extends StateNotifier<SignUpData> {
  SignUpState() : super(SignUpData());

  void setRole(String role) {
    state = state.copyWith(roles: role);
  }

  void updateUserFormData(Map<String, dynamic> formData) {
    state = state.copyWith(
      fullname: formData['fullname'] as String?,
      username: formData['username'] as String?,
      email: formData['email'] as String?,
      password: formData['password'] as String?,
      icNo: formData['icNo'] as String?,
    );
  }

  void updateMerchantFormDataA(
      Map<String, dynamic> formData, String categoryType) {
    state = state.copyWith(
      fullname: formData['fullname'] as String?,
      password: formData['password'] as String?,
      icNo: formData['icNo'] as String?,
      categoryType:
          categoryType == 'Places/Attractions' ? 'Places' : categoryType,
    );
  }

  void updateMerchantFormDataB(Map<String, dynamic> formData, List<File> photos,
      File? logo, List<String> labels) {
    state = state.copyWith(
        businessName: formData['mName'] as String?,
        email: formData['mEmail'] as String?,
        description: formData['mDesc'] as String?,
        contactNumber: formData['mContactNo'] as String?,
        operatingHours: formData['mOpHoursNo'] as String?,
        address:
            '${formData['address']}, ${formData['postcode']}, ${formData['city']}, ${formData['state']}'
                as String?,
        photoUrls: photos, //photos.map((photo) => photo.path).toList(),
        logoUrl: logo, //logo?.path ?? '',
        labels: labels,
        isApproved: false);
  }
}
