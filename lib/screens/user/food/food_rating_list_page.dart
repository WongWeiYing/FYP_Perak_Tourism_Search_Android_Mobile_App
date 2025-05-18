import 'package:flutter/widgets.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/data/food_data.dart';
import 'package:go_perak/screens/user/food/food_write_review_page.dart';
import 'package:go_perak/page_base/rating_list_page.dart';
import 'package:go_perak/utils/abstract%20class/rating_item_abstract.dart';
import 'package:go_perak/utils/state_provider.dart/food_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FoodRatingListPage extends ConsumerWidget {
  final FoodData foodData;

  const FoodRatingListPage({super.key, required this.foodData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratings = ref.watch(foodReviewProvider(foodData.foodID));
    final foodDetail = ref.watch(foodProvider(foodData.foodID));

    return RatingListPageBase(
      ratingItem: RatingFood(foodDetail.value!, () async {
        final result = await Navigator.pushNamed(
            context, CustomRouter.foodWriteReview,
            arguments: FoodWriteReviewPage(foodData: foodData));

        if (result == true) {
          ref.invalidate(foodProvider(foodData.foodID));
          ref.invalidate(foodListProvider);
          ref.invalidate(foodReviewProvider(foodData.foodID));
        }
      }),
      ratings: ratings.value ?? [],
    );
  }
}
