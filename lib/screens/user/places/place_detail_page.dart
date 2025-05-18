import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/data/rating_data.dart';
import 'package:go_perak/helper/map_helper.dart';
import 'package:go_perak/screens/map_page.dart';
import 'package:go_perak/screens/user/places/place_rating_list_page.dart';
import 'package:go_perak/screens/user/places/place_write_review_page.dart';
import 'package:go_perak/utils/state_provider.dart/place_state.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:go_perak/widgets/button/wishlist_button.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:go_perak/widgets/rating_list.dart';
import 'package:go_perak/widgets/star.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlaceDetailPage extends StatefulHookConsumerWidget {
  final String placeID;
  const PlaceDetailPage({super.key, required this.placeID});
  @override
  PlaceDetailPageState createState() => PlaceDetailPageState();
}

class PlaceDetailPageState extends ConsumerState<PlaceDetailPage> {
  late ScrollController _scrollController;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > _lastOffset) {
      } else {}
      _lastOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider = ref.watch(placeReviewProvider(widget.placeID));
    final placeProviderResult = ref.watch(placeProvider(widget.placeID));

    return placeProviderResult.when(
        data: (place) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  pinned: true,
                  floating: true,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SavelistButton(
                        itemID: place.placeID,
                        type: 'Places',
                      ),
                    ),
                  ],
                  snap: true,
                  expandedHeight: 250.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      place.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gapHeight12,
                      Text(
                        place.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      gapHeight12,
                      Text(place.description, style: AppTextStyle.bodyText),
                      gapHeight12,
                      RatingStars(
                          rating: place.averageRating,
                          review: place.ratingCount),
                      gapHeight12,
                      Text('Location', style: AppTextStyle.header3),
                      gapHeight8,
                      Text(place.address),
                      gapHeight12,
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, CustomRouter.map,
                              arguments: MapPage(address: place.address));
                        },
                        child:
                            Image.network(generateStaticMapUrl(place.address)),
                      ),
                      gapHeight32,
                      if (reviewProvider is AsyncData<List<RatingData>> &&
                          reviewProvider.value.isNotEmpty) ...[
                        Row(
                          children: [
                            Text('Ratings', style: AppTextStyle.header3),
                            if (reviewProvider.value.length > 1) ...[
                              const Spacer(),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, CustomRouter.placeRatingList,
                                        arguments: PlaceRatingListPage(
                                          placeData: placeProviderResult.value!,
                                        ));
                                  },
                                  child: const Text('View More'))
                            ]
                          ],
                        ),
                        gapHeight16,
                        RatingList(
                          ratings: reviewProvider.value,
                          noDisplay: reviewProvider.value.length > 3
                              ? 3
                              : reviewProvider.value.length,
                        ),
                      ],
                      gapHeight32,
                      PrimaryButton(
                        title: 'Write a review',
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                              context, CustomRouter.placeWriteReview,
                              arguments: PlaceWriteReviewPage(
                                placeData: place,
                              ));

                          if (result == true) {
                            ref.invalidate(placeProvider(widget.placeID));
                            ref.invalidate(placesProvider);
                            ref.invalidate(placeReviewProvider(widget.placeID));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => Center(child: showLoading()), // Loading state
        error: (err, stack) {
          return Center(child: Text(stack.toString()));
        } // Error state
        );
  }
}
