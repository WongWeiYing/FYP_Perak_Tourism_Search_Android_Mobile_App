import 'package:cloud_firestore/cloud_firestore.dart';

class RatingData {
  final String userID;
  final String username;
  final double rating;
  final String comment;
  final List<String> photoUrls;
  final Timestamp createdAt;
  final String profilePic;

  RatingData({
    required this.userID,
    required this.username,
    required this.rating,
    required this.comment,
    required this.photoUrls,
    required this.createdAt,
    required this.profilePic,
  });

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
        userID: json['userID'],
        username: json['username'],
        rating: (json['rating'] ?? 0).toDouble(),
        comment: json['comment'],
        photoUrls: List<String>.from(json['photoUrls'] ?? []),
        createdAt: json['createdAt'] ?? Timestamp.now(),
        profilePic: json['profilePic']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'username': username,
      'rating': rating,
      'comment': comment,
      'photoUrls': photoUrls,
      'createdAt': createdAt,
      'profilePic': profilePic
    };
  }
}
