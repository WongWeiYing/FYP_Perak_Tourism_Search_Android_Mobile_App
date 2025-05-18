import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/generated/assets.gen.dart';

Widget buildGreetingRow(
    BuildContext context, String name, String photo, GestureDetector? gd) {
  return Row(
    children: [
      SizedBox(
          width: 70,
          height: 70,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: photo.length == 0
                ? Image.asset(
                    Assets.images.userDefault.path,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    photo,
                    fit: BoxFit.cover,
                  ),
          )),
      gapWidth16,
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello,',
              style: AppTextStyle.bodyText,
            ),
            gapHeight8,
            Text(
              name,
              style: AppTextStyle.header3,
            ),
          ],
        ),
      ),
      const Spacer(),
      gd ?? const SizedBox.shrink(),
    ],
  );
}
