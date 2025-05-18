import 'package:go_perak/data/activity_data.dart';
import 'package:go_perak/utils/abstract%20class/write_review_page_base.dart';

class ActivityWriteReviewPage extends WriteReviewPageBase {
  final ActivityData activityData;

  ActivityWriteReviewPage({super.key, required this.activityData})
      : super(
            title: activityData.businessName,
            bucketName: 'rating-photos',
            collectionName: 'Activities',
            itemID: activityData.activityID,
            averageRating: activityData.averageRating,
            ratingCount: activityData.ratingCount);
}
