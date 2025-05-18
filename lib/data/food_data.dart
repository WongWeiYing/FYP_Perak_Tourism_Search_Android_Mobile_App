import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_perak/data/food_activity_data.dart';

// class FoodData {
//   final String foodID;
//   final String businessName;
//   final String businessLogo;
//   final String businessEmail;
//   final String contactNumber;
//   final String operatingHours;
//   final List<String> photoUrls;
//   final String description;
//   final String address;
//   final double averageRating;
//   final int ratingCount;
//   final bool isApproved;
//   final Timestamp createdAt;
//   final List<String> tags;

//   FoodData(
//       {required this.foodID,
//       required this.businessName,
//       required this.businessLogo,
//       required this.contactNumber,
//       required this.operatingHours,
//       required this.businessEmail,
//       required this.photoUrls,
//       required this.description,
//       required this.address,
//       required this.averageRating,
//       required this.ratingCount,
//       required this.isApproved,
//       required this.tags,
//       required this.createdAt});

//   factory FoodData.fromJson(Map<String, dynamic> json, String? id) {
//     return FoodData(
//       foodID: id ?? json['foodID'],
//       businessName: json['businessName'],
//       businessLogo: json['businessLogo'],
//       contactNumber: json['contactNumber'],
//       operatingHours: json['operatingHours'],
//       businessEmail: json['businessEmail'],
//       photoUrls: List<String>.from(json['photoUrls'] ?? []),
//       description: json['description'],
//       address: json['address'],
//       averageRating: json['averageRating'].toDouble(),
//       ratingCount: json['ratingCount'],
//       isApproved: json['isApproved'],
//       createdAt: json['createdAt'] ?? Timestamp.now(),
//       tags: List<String>.from(json['tags'] ?? []),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'foodID': foodID,
//       'businessName': businessName,
//       'businessLogo': businessLogo,
//       'contactNumber': contactNumber,
//       'operatingHours': operatingHours,
//       'businessEmail': businessEmail,
//       'photoUrls': photoUrls,
//       'description': description,
//       'address': address,
//       'averageRating': averageRating,
//       'ratingCount': ratingCount,
//       'isApproved': isApproved,
//       'createdAt': createdAt,
//       'tags': tags
//     };
//   }
// }

class FoodData extends FoodActivityDataBase {
  final String foodID;
  @override
  final String businessName;
  @override
  final String businessLogo;
  @override
  final String businessEmail;
  @override
  final String contactNumber;
  @override
  final String operatingHours;
  @override
  final List<String> photoUrls;
  @override
  final String description;
  @override
  final String address;
  @override
  final double averageRating;
  @override
  final int ratingCount;
  @override
  final bool isApproved;
  @override
  final Timestamp createdAt;
  @override
  final List<String> tags;

  FoodData({
    required this.foodID,
    required this.businessName,
    required this.businessLogo,
    required this.contactNumber,
    required this.operatingHours,
    required this.businessEmail,
    required this.photoUrls,
    required this.description,
    required this.address,
    required this.averageRating,
    required this.ratingCount,
    required this.isApproved,
    required this.tags,
    required this.createdAt,
  });

  factory FoodData.fromJson(Map<String, dynamic> json, String? foodID) {
    return FoodData(
      foodID: foodID ?? json['foodID'],
      businessName: json['businessName'],
      businessLogo: json['businessLogo'],
      contactNumber: json['contactNumber'],
      operatingHours: json['operatingHours'],
      businessEmail: json['businessEmail'],
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      description: json['description'],
      address: json['address'],
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
      isApproved: json['isApproved'] ?? false,
      createdAt: json['createdAt'] ?? Timestamp.now(),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodID': foodID,
      'businessName': businessName,
      'businessLogo': businessLogo,
      'contactNumber': contactNumber,
      'operatingHours': operatingHours,
      'businessEmail': businessEmail,
      'photoUrls': photoUrls,
      'description': description,
      'address': address,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
      'isApproved': isApproved,
      'createdAt': createdAt,
      'tags': tags,
    };
  }
}
