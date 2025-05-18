import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/repositories/wishlist_repo.dart';
import 'package:go_perak/screens/user/activities/activity_detail_page.dart';
import 'package:go_perak/screens/user/food/food_detail_page.dart';
import 'package:go_perak/screens/user/places/place_detail_page.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:go_perak/widgets/bar/app_bottom_nav_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class SavelistPage extends HookConsumerWidget {
  const SavelistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savelistAsync = ref.watch(savelistProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const ProjectAppBottomNav(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Your Savelist"),
      ),
      body: savelistAsync.when(
        loading: () => Center(
          child: Lottie.asset(
            'assets/animations/loading_animation.json',
            width: 200.w,
            height: 200.h,
          ),
        ),
        error: (e, st) => const Center(child: Text("Something went wrong")),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/empty_list_animation.json',
                    width: 200.w,
                    height: 200.h,
                  ),
                  Text('You have not saved any items yet',
                      style: AppTextStyle.bodyText),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.only(bottom: 16.w),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];

              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                child: GestureDetector(
                  onTap: () async {
                    try {
                      if (item.type == 'Food') {
                        Navigator.pushNamed(context, CustomRouter.foodDetail,
                            arguments: FoodDetailPage(
                              foodID: item.itemID,
                            ));
                      } else if (item.type == 'Activity') {
                        Navigator.pushNamed(
                            context, CustomRouter.activityDetail,
                            arguments: ActivityDetailPage(
                              activityID: item.itemID,
                            ));
                      } else {
                        Navigator.pushNamed(context, CustomRouter.placeDetail,
                            arguments: PlaceDetailPage(
                              placeID: item.itemID,
                            ));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Error loading food details: $e')),
                      );
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Image.network(
                          item.photo,
                          width: 130.w,
                          height: 130.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 130);
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: AppTextStyle.header2,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            gapHeight8,
                            Text(
                              item.address,
                              style: AppTextStyle.bodyText,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          final userId = ref.read(currentUserProvider).userID!;
                          await WishlistRepo()
                              .removeItemFromSavelist(userId, item.itemID);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
