import 'package:cloud_firestore/cloud_firestore.dart';

class SavelistData {
  final String photo;
  final String name;
  final String address;
  final String itemID;
  final String type;

  SavelistData(
      {required this.photo,
      required this.address,
      required this.name,
      required this.itemID,
      required this.type});

  factory SavelistData.fromDocument(
      DocumentSnapshot doc, String itemID, String itemType) {
    final data = doc.data() as Map<String, dynamic>;

    final photo = data['image'] ?? data['photoUrls']?[0] ?? '';
    final address = data['address'] ?? '';
    final name = data['name'] ?? data['businessName'] ?? 'Unknown';

    return SavelistData(
        photo: photo,
        address: address,
        name: name,
        itemID: itemID,
        type: itemType);
  }
}
