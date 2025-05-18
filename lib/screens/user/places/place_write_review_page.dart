import 'package:go_perak/data/place_data.dart';
import 'package:go_perak/utils/abstract%20class/write_review_page_base.dart';

class PlaceWriteReviewPage extends WriteReviewPageBase {
  final PlaceData placeData;

  PlaceWriteReviewPage({super.key, required this.placeData})
      : super(
            title: placeData.name,
            bucketName: 'rating-photos',
            // userID: "TwDyJb9shMc3tXj2xcGGHH3eRRn2",
            collectionName: 'Places',
            itemID: placeData.placeID,
            //username: 'Emm',
            averageRating: placeData.averageRating,
            ratingCount: placeData.ratingCount);

  // @override
  // Future<void> onSubmitReview({
  //   required double rating,
  //   required String comment,
  //   required List<String> photoUrls,
  // }) async {
  //   final ratingData = {
  //     'userID': "TwDyJb9shMc3tXj2xcGGHH3eRRn2",
  //     'username': 'Emm',
  //     'rating': rating.toInt(),
  //     'comment': comment,
  //     'photoUrls': photoUrls,
  //     'createdAt': FieldValue.serverTimestamp(),
  //   };
  //   await FirebaseFirestore.instance
  //       .collection('Places')
  //       .doc(placeData.placeId)
  //       .collection('Ratings')
  //       .add(ratingData);
  // }
}
