class Address {
  final String street;
  final String postCode;
  final String city;
  final String state;
  final String country;

  const Address({
    this.street = '',
    this.postCode = '',
    this.city = '',
    this.state = '',
    this.country = '',
  });

  String get fullAddress =>
      isEmpty ? "" : "$street, $postCode, $city, $state, $country";

  bool get isEmpty =>
      street.isEmpty &&
      postCode.isEmpty &&
      city.isEmpty &&
      state.isEmpty &&
      country.isEmpty;

  Address.fromJson(dynamic json)
      : street = json['address'] ?? '',
        postCode = json["postCode"] ?? '',
        city = json["city"] ?? '',
        state = json["state"] ?? '',
        country = json["country"] ?? '';
}
