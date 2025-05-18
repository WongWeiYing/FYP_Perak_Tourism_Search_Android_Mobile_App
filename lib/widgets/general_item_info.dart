import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/constants/app_color.dart';

class GeneralItemInfo extends StatelessWidget {
  final String name;
  final String location;
  final double? rating;
  final int? review;

  const GeneralItemInfo({
    super.key,
    required this.name,
    required this.location,
    this.rating,
    this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gapHeight4,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            name,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, size: 14.sp, color: Colors.orange),
                  gapWidth4,
                  Expanded(
                    child: Text(
                      location,
                      style: AppTextStyle.caption
                          .copyWith(color: AppColor.labelBlack),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              gapHeight4,
              if (rating != null)
                Row(
                  children: [
                    Icon(Icons.star, size: 14.sp, color: Colors.amber),
                    SizedBox(width: 4.w),
                    Text(
                      rating!.toStringAsFixed(1),
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.labelBlack,
                      ),
                    ),
                    gapWidth8,
                    Text(
                      '$review Reviews',
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.labelBlack,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
