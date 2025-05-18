import 'package:flutter/widgets.dart';
import 'package:go_perak/data/food_data.dart';
import 'package:go_perak/data/place_data.dart';

abstract class RatingItem {
  String get title;
  double get averageRating;
  int get ratingCount;
  VoidCallback get onCommentPressed;
}

class RatingPlace extends RatingItem {
  final PlaceData place;
  final VoidCallback onCommentPressedCallback;
  RatingPlace(this.place, this.onCommentPressedCallback);

  @override
  String get title => place.name;

  @override
  double get averageRating => place.averageRating;

  @override
  int get ratingCount => place.ratingCount;

  @override
  VoidCallback get onCommentPressed => onCommentPressedCallback;
}

class RatingFood extends RatingItem {
  final FoodData food;
  final VoidCallback onCommentPressedCallback;
  RatingFood(this.food, this.onCommentPressedCallback);

  @override
  String get title => food.businessName;

  @override
  double get averageRating => food.averageRating;

  @override
  int get ratingCount => food.ratingCount;

  @override
  VoidCallback get onCommentPressed => onCommentPressedCallback;
}
