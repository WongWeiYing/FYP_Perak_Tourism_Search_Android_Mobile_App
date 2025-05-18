import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_enum.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/data/rating_data.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/utils/state_provider.dart/food_state.dart';
import 'package:go_perak/widgets/category_chip.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:go_perak/widgets/rating_list.dart';
import 'package:go_perak/widgets/star.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MerchantBusinessReviewsPage extends StatefulHookConsumerWidget {
  final String businessID;
  final String businessType;

  const MerchantBusinessReviewsPage({
    super.key,
    required this.businessID,
    required this.businessType,
  });

  @override
  ConsumerState<MerchantBusinessReviewsPage> createState() =>
      _MerchantBusinessReviewsPageState();
}

class _MerchantBusinessReviewsPageState
    extends ConsumerState<MerchantBusinessReviewsPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<RatingData>> businessDetail =
        widget.businessType == 'Food'
            ? ref.watch(foodReviewProvider(widget.businessID))
            : ref.watch(activityReviewProvider(widget.businessID));

    final filterTypes = [
      FilterType.all,
      FilterType.oneStar,
      FilterType.twoStar,
      FilterType.threeStar,
      FilterType.fourStar,
      FilterType.fiveStar
    ];

    final selectedCategory = useState<FilterType>(FilterType.all);

    return businessDetail.when(
      loading: () => Center(child: showLoading()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (ratings) {
        final filteredRatings = ratings.where((rating) {
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

        final double averageRating = ratings.isEmpty
            ? 0
            : ratings.map((r) => r.rating).reduce((a, b) => a + b) /
                ratings.length;
        final int ratingCount = ratings.length;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      averageRating.toStringAsFixed(1),
                      style: AppTextStyle.bigNumber,
                    ),
                  ),
                  Center(
                    child: RatingStars(
                      rating: averageRating,
                      starSize: 30,
                    ),
                  ),
                  Center(child: Text('$ratingCount Reviews')),
                  gapHeight16,
                  Center(
                    child: Wrap(
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
                  ),
                  gapHeight32,
                  RatingList(ratings: filteredRatings),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
