import 'package:flutter/widgets.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/data/activity_data.dart';
import 'package:go_perak/screens/user/activities/activity_write_review_page.dart';
import 'package:go_perak/page_base/rating_list_page.dart';
import 'package:go_perak/utils/abstract%20class/rating_item_abstract.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/utils/state_provider.dart/food_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ActivityRatingListPage extends ConsumerWidget {
  final ActivityData activityData;

  const ActivityRatingListPage({super.key, required this.activityData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratings = ref.watch(foodReviewProvider(activityData.activityID));
    final foodDetail = ref.watch(foodProvider(activityData.activityID));

    return RatingListPageBase(
      ratingItem: RatingFood(foodDetail.value!, () async {
        final result = await Navigator.pushNamed(
            context, CustomRouter.activityWriteReview,
            arguments: ActivityWriteReviewPage(activityData: activityData));

        if (result == true) {
          ref.invalidate(activityProvider(activityData.activityID));
          ref.invalidate(activityListProvider);
          ref.invalidate(activityReviewProvider(activityData.activityID));
        }
      }),
      ratings: ratings.value ?? [],
    );
  }
}
