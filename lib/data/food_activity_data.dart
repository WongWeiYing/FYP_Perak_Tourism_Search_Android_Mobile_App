import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FoodActivityDataBase {
  String get businessName;
  String get businessLogo;
  String get contactNumber;
  String get operatingHours;
  String get businessEmail;
  List<String> get photoUrls;
  String get description;
  String get address;
  double get averageRating;
  int get ratingCount;
  bool get isApproved;
  Timestamp get createdAt;
  List<String> get tags;
}
