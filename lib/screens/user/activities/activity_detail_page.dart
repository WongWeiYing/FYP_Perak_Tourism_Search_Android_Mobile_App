import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/data/rating_data.dart';
import 'package:go_perak/helper/map_helper.dart';
import 'package:go_perak/repositories/chat_repo.dart';
import 'package:go_perak/screens/chat_room_page.dart';
import 'package:go_perak/screens/map_page.dart';
import 'package:go_perak/screens/user/activities/activity_rating_list_pgae.dart';
import 'package:go_perak/screens/user/activities/activity_write_review_page.dart';
import 'package:go_perak/screens/user/food/food_detail_page.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:go_perak/widgets/auto_carousel_widget.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:go_perak/widgets/button/wishlist_button.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:go_perak/widgets/rating_list.dart';
import 'package:go_perak/widgets/star.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ActivityDetailPage extends StatefulHookConsumerWidget {
  final String activityID;

  const ActivityDetailPage({super.key, required this.activityID});

  @override
  ActivityDetailPageState createState() => ActivityDetailPageState();
}

class ActivityDetailPageState extends ConsumerState<ActivityDetailPage> {
  late ScrollController _scrollController;
  double lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      lastOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodDataProviderResult =
        ref.watch(activityProvider(widget.activityID));
    final reviewProvider = ref.watch(activityReviewProvider(widget.activityID));
    final currentUser = ref.watch(currentUserProvider);
    ChatService chatService = ChatService();

    return foodDataProviderResult.when(
      data: (data) {
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
                      itemID: data.activityID,
                      type: 'Activities',
                    ),
                  ),
                ],
                snap: true,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: data.photoUrls.length > 1
                      ? AutoCarousel(images: data.photoUrls)
                      : Image.network(
                          data.photoUrls[0],
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
                      data.businessName,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    gapHeight12,
                    Text(data.description, style: AppTextStyle.bodyText),
                    gapHeight12,
                    RatingStars(
                        rating: data.averageRating, review: data.ratingCount),
                    gapHeight12,
                    Text('Operating Hours', style: AppTextStyle.header3),
                    gapHeight8,
                    Text(data.operatingHours, style: AppTextStyle.bodyText),
                    gapHeight16,
                    Text('Contact Information', style: AppTextStyle.header3),
                    gapHeight8,
                    GestureDetector(
                      onTap: () async {
                        String? merchantID =
                            await getMerchantIdFromBusinessId(data.activityID);

                        String chatRoomId =
                            await chatService.getOrCreateChatRoom(
                                currentUser.userID!, merchantID ?? '');

                        print(merchantID);

                        Navigator.pushNamed(
                          context,
                          CustomRouter.chatRoom,
                          arguments: ChatRoomPage(
                            chatRoomId: chatRoomId,
                            otherUserId: merchantID ?? '',
                            otherUserName: data.businessName,
                            otherUserPhotoUrl: data.businessLogo,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                          ),
                          gapWidth12,
                          const Text(
                            'Message me here',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    gapHeight8,
                    Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                        ),
                        gapWidth12,
                        Text(data.businessEmail, style: AppTextStyle.bodyText),
                      ],
                    ),
                    gapHeight8,
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                        ),
                        gapWidth12,
                        Text(data.contactNumber, style: AppTextStyle.bodyText),
                      ],
                    ),
                    gapHeight16,
                    Text('Location', style: AppTextStyle.header3),
                    gapHeight8,
                    Text(data.address),
                    gapHeight12,
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, CustomRouter.map,
                            arguments: MapPage(address: data.address));
                      },
                      child: Image.network(generateStaticMapUrl(data.address)),
                    ),
                    gapHeight32,
                    if (reviewProvider is AsyncData<List<RatingData>> &&
                        reviewProvider.value.isNotEmpty) ...[
                      Row(
                        children: [
                          Text('Ratings', style: AppTextStyle.header3),
                          if (reviewProvider.value.length > 3) ...[
                            const Spacer(),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, CustomRouter.activityRatingList,
                                      arguments: ActivityRatingListPage(
                                          activityData: data));
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
                            context, CustomRouter.activityWriteReview,
                            arguments: ActivityWriteReviewPage(
                              activityData: data,
                            ));

                        if (result == true) {
                          ref.invalidate(activityProvider(widget.activityID));
                          ref.invalidate(activityListProvider);
                          ref.invalidate(
                              activityReviewProvider(widget.activityID));
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
      loading: () => Center(child: showLoading()),
      error: (err, stack) {
        return Center(child: Text(stack.toString()));
      },
    );
  }
}
