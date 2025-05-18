import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_border.dart';
import 'package:go_perak/data/food_data.dart';
import 'package:go_perak/widgets/button/wishlist_button.dart';
import 'package:go_perak/widgets/general_item_info.dart';

class FoodGridView extends StatelessWidget {
  final List<FoodData> foodList;
  final Function(FoodData) onItemTap;
  final bool? showTags;
  final double? aspectRatio;
  final int? itemLength;
  final ScrollPhysics? physics;
  final int? crossAxisCount;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;

  const FoodGridView(
      {super.key,
      required this.foodList,
      required this.onItemTap,
      this.showTags = false,
      this.aspectRatio,
      this.itemLength,
      this.physics,
      this.crossAxisSpacing,
      this.crossAxisCount,
      this.mainAxisSpacing});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount ?? 2,
        crossAxisSpacing: crossAxisSpacing ?? 5.w,
        mainAxisSpacing: mainAxisSpacing ?? 5.h,
        childAspectRatio: aspectRatio ?? 0.59,
      ),
      itemCount: itemLength ?? foodList.length,
      itemBuilder: (context, index) {
        final food = foodList[index];
        return GestureDetector(
          onTap: () => onItemTap(food),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppBorder.cardBorder,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        child: Image.network(
                          food.photoUrls[0],
                          width: double.infinity,
                          height: 200.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: SavelistButton(
                          itemID: food.foodID,
                          type: 'Food',
                        ),
                      ),
                    ],
                  ),
                ),
                GeneralItemInfo(
                  name: food.businessName,
                  location: food.address,
                  rating: food.averageRating,
                  review: food.ratingCount,
                ),
                if (showTags == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: food.tags.take(4).map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor:
                              const Color.fromARGB(255, 254, 255, 255),
                          labelStyle: const TextStyle(color: Colors.black),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
