import 'package:flutter/widgets.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/data/place_data.dart';
import 'package:go_perak/screens/user/places/place_write_review_page.dart';
import 'package:go_perak/page_base/rating_list_page.dart';
import 'package:go_perak/utils/abstract%20class/rating_item_abstract.dart';
import 'package:go_perak/utils/state_provider.dart/place_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlaceRatingListPage extends ConsumerWidget {
  final PlaceData placeData;

  const PlaceRatingListPage({super.key, required this.placeData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratings = ref.watch(placeReviewProvider(placeData.placeID));
    final placeDetail = ref.watch(placeProvider(placeData.placeID));

    return RatingListPageBase(
      ratingItem: RatingPlace(placeDetail.value!, () async {
        final result = await Navigator.pushNamed(
            context, CustomRouter.placeWriteReview,
            arguments: PlaceWriteReviewPage(placeData: placeData));

        if (result == true) {
          ref.invalidate(placeProvider(placeData.placeID));
          ref.invalidate(placesProvider);
          ref.invalidate(placeReviewProvider(placeData.placeID));
        }
      }),
      ratings: ratings.value ?? [],
    );
  }
}
