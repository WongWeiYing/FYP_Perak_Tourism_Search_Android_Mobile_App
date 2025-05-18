import 'dart:io';

class SignUpData {
  final String? icNo;
  final String? username;
  final String? fullname;
  final String? email;
  final String? roles;
  final String? password;
  final String? businessName;
  final String? description;
  final String? phoneNumber;
  final String? registrationNumber;
  final String? address;
  final String? operatingHours;
  final String? createdAt;
  final String? contactNumber;
  final List<File>? photoUrls;
  final File? logoUrl;
  final bool? isApproved;
  final String? categoryType;
  final List<String>? labels;

  SignUpData(
      {this.icNo,
      this.fullname,
      this.username,
      this.roles,
      this.email,
      this.password,
      this.businessName,
      this.description,
      this.phoneNumber,
      this.registrationNumber,
      this.address,
      this.operatingHours,
      this.createdAt,
      this.contactNumber,
      this.photoUrls = const [],
      this.logoUrl,
      this.isApproved,
      this.labels = const [],
      this.categoryType});

  SignUpData copyWith(
      {String? icNo,
      String? fullname,
      String? username,
      String? roles,
      String? email,
      String? password,
      String? businessName,
      String? description,
      String? phoneNumber,
      String? registrationNumber,
      String? address,
      String? operatingHours,
      String? createdAt,
      String? contactNumber,
      bool? isApproved,
      File? logoUrl,
      List<String>? labels,
      List<File>? photoUrls,
      String? categoryType}) {
    return SignUpData(
        icNo: icNo ?? this.icNo,
        fullname: fullname ?? this.fullname,
        username: username ?? this.username,
        roles: roles ?? this.roles,
        email: email ?? this.email,
        password: password ?? this.password,
        businessName: businessName ?? this.businessName,
        description: description ?? this.description,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        registrationNumber: registrationNumber ?? this.registrationNumber,
        address: address ?? this.address,
        operatingHours: operatingHours ?? this.operatingHours,
        logoUrl: logoUrl ?? this.logoUrl,
        photoUrls: photoUrls ?? this.photoUrls,
        labels: labels ?? this.labels,
        createdAt: createdAt ?? this.createdAt,
        contactNumber: contactNumber ?? this.contactNumber,
        categoryType: categoryType ?? this.categoryType,
        isApproved: isApproved ?? this.isApproved);
  }
}
