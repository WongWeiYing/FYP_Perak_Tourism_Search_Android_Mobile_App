import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_enum.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/data/rating_data.dart';
import 'package:go_perak/utils/abstract%20class/rating_item_abstract.dart';
import 'package:go_perak/widgets/bar/app_bar.dart';
import 'package:go_perak/widgets/category_chip.dart';
import 'package:go_perak/widgets/rating_list.dart';
import 'package:go_perak/widgets/star.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RatingListPageBase extends StatefulHookConsumerWidget {
  final RatingItem ratingItem;
  final List<RatingData> ratings;

  const RatingListPageBase(
      {super.key, required this.ratingItem, required this.ratings});

  @override
  ConsumerState<RatingListPageBase> createState() => _RatingListPageBaseState();
}

class _RatingListPageBaseState extends ConsumerState<RatingListPageBase> {
  @override
  Widget build(BuildContext context) {
    final filterTypes = [
      FilterType.all,
      FilterType.oneStar,
      FilterType.twoStar,
      FilterType.threeStar,
      FilterType.fourStar,
      FilterType.fiveStar
    ];

    final selectedCategory = useState<FilterType>(FilterType.all);

    final filteredRatings = widget.ratings.where((rating) {
      switch (selectedCategory.value) {
        case FilterType.oneStar:
          return rating.rating == 1;
        case FilterType.twoStar:
          return rating.rating == 2;
        case FilterType.threeStar:
          return rating.rating == 3;
        case FilterType.fourStar:
          return rating.rating == 4;
        case FilterType.fiveStar:
          return rating.rating == 5;
        case FilterType.all:
          return true;
      }
    }).toList();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: ProjectAppBar(
          title: widget.ratingItem.title,
          actions: [
            IconButton(
                onPressed: () {
                  widget.ratingItem.onCommentPressed.call();
                },
                icon: const Icon(Icons.comment))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Reviews", style: AppTextStyle.header1),
                Center(
                  child: Text(
                    widget.ratingItem.averageRating.toString(),
                    style: AppTextStyle.bigNumber,
                  ),
                ),
                Center(
                    child: RatingStars(
                  rating: widget.ratingItem.averageRating,
                  starSize: 30,
                )),
                Center(child: Text('${widget.ratingItem.ratingCount} Reviews')),
                gapHeight16,
                Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children: filterTypes.map((filter) {
                    return SizedBox(
                      width: 100,
                      child: GestureDetector(
                        onTap: () => selectedCategory.value = filter,
                        child: CategoryChip(
                          title: filter.value,
                          isSelected: selectedCategory.value == filter,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                gapHeight32,
                RatingList(ratings: filteredRatings)
              ],
            ),
          ),
        ));
  }
}
