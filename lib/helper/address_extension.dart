import 'package:go_perak/data/address.dart';

extension AddressParser on String {
  Address toAddress() {
    final postcodeRegex = RegExp(r'\b\d{5}\b');
    final match = postcodeRegex.firstMatch(this);

    if (match != null) {
      final postcode = match.group(0)!;
      final beforePostcode =
          substring(0, match.start).trim().replaceAll(RegExp(r'[,\s]+$'), '');
      final afterPostcode = substring(match.end).trim();

      // Split after postcode by comma
      final parts = afterPostcode.split(',').map((e) => e.trim()).toList();
      print(parts);

      return Address(
        street: beforePostcode,
        postCode: postcode,
        city: parts[1],
        state: parts.length > 1 ? parts[2] : '',
        country: 'Malaysia',
      );
    }

    // Fallback: empty address if no postcode found
    return Address(
      street: '',
      postCode: '',
      city: '',
      state: '',
      country: '',
    );
  }
}
