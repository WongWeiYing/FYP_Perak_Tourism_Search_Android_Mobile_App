import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';

class RatingStars extends HookWidget {
  final double rating;
  final int? review;
  final double starSize;

  RatingStars(
      {super.key, this.review, required this.rating, this.starSize = 20});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: Colors.amber, size: starSize),
        if (hasHalfStar)
          Icon(Icons.star_half, color: Colors.amber, size: starSize),
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, color: Colors.amber, size: starSize),
        if (review != null) ...[
          gapWidth12,
          Text(
            '$review Reviews',
            style: AppTextStyle.caption,
          ),
        ]
      ],
    );
  }
}
