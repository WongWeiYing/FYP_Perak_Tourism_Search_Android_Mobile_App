class PlaceData {
  final String placeID;
  final String name;
  final String image;
  final String description;
  final String address;
  final double averageRating;
  final int ratingCount;

  PlaceData({
    required this.placeID,
    required this.name,
    required this.image,
    required this.description,
    required this.address,
    required this.averageRating,
    required this.ratingCount,
  });

  factory PlaceData.fromJson(Map<String, dynamic> json) {
    return PlaceData(
      placeID: json['placeID'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      address: json['address'],
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      ratingCount: (json['ratingCount'] ?? 0).toInt(),
    );
  }

  factory PlaceData.fromJsonWithID(Map<String, dynamic> json, String id) {
    return PlaceData(
      placeID: id,
      name: json['name'],
      image: json['image'],
      description: json['description'],
      address: json['address'],
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      ratingCount: (json['ratingCount'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeID': placeID,
      'name': name,
      'image': image,
      'description': description,
      'address': address,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
    };
  }
}
