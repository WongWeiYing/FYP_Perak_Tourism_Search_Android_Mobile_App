class MerchantData {
  final String businessID;
  final String fullname;
  final String categoryType;

  MerchantData(
      {required this.businessID,
      required this.fullname,
      required this.categoryType});

  factory MerchantData.fromJson(Map<String, dynamic> json, String? id) {
    return MerchantData(
      businessID: json['business'],
      fullname: json['fullname'],
      categoryType: json['categoryType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business': businessID,
      'fullname': fullname,
      'categoryType': categoryType,
    };
  }
}
