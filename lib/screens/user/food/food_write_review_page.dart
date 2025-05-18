import 'package:go_perak/data/food_data.dart';
import 'package:go_perak/utils/abstract%20class/write_review_page_base.dart';

class FoodWriteReviewPage extends WriteReviewPageBase {
  final FoodData foodData;

  FoodWriteReviewPage({super.key, required this.foodData})
      : super(
            title: foodData.businessName,
            bucketName: 'rating-photos',
            //userID: "TwDyJb9shMc3tXj2xcGGHH3eRRn2",
            collectionName: 'Food',
            itemID: foodData.foodID,
            //username: '',
            averageRating: foodData.averageRating,
            ratingCount: foodData.ratingCount);
}
