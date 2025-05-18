import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_border.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/data/activity_data.dart';
import 'package:go_perak/data/food_data.dart';
import 'package:go_perak/data/place_data.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/screens/user/activities/activity_detail_page.dart';
import 'package:go_perak/screens/user/food/food_detail_page.dart';
import 'package:go_perak/screens/user/places/place_detail_page.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/utils/state_provider.dart/food_state.dart';
import 'package:go_perak/utils/state_provider.dart/place_state.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:go_perak/widgets/bar/app_bottom_nav_bar.dart';
import 'package:go_perak/widgets/button/text_button.dart';
import 'package:go_perak/widgets/general_item_info.dart';
import 'package:go_perak/widgets/greeting_row_widget.dart';
import 'package:go_perak/widgets/grid_view/food_grid_view_widget.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(placesProvider);
    final foodListAsync = ref.watch(foodListProvider);
    final activityListAsync = ref.watch(activityListProvider);
    final userDetail = ref.watch(userDetailsProvider);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const ProjectAppBottomNav(),
        backgroundColor: AppColor.white,
        body: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          child: placesAsync.when(
            loading: () => SizedBox.expand(
              child: Center(child: showLoading()),
            ),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (places) {
              return foodListAsync.when(
                  loading: () => SizedBox.expand(
                        child: Center(child: showLoading()),
                      ),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                  data: (foodList) {
                    return activityListAsync.when(
                        loading: () => SizedBox.expand(
                              child: Center(child: showLoading()),
                            ),
                        error: (error, stack) =>
                            Center(child: Text('Error: $error')),
                        data: (activities) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildGreetingRow(
                                    context,
                                    userDetail.value!.username,
                                    userDetail.value!.profilePic,
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            CustomRouter.exploreSearch);
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.search_outlined),
                                      ),
                                    )),
                                gapHeight12,
                                const Divider(),
                                gapHeight12,
                                Text('Categories', style: AppTextStyle.header2),
                                gapHeight16,
                                Row(
                                  children: [
                                    _buildCategoryCard(
                                        'Food',
                                        Icons.ramen_dining,
                                        const Color.fromARGB(
                                            255, 129, 195, 225), () {
                                      Navigator.pushNamed(
                                          context, CustomRouter.foodList);
                                    }),
                                    gapWidth8,
                                    _buildCategoryCard(
                                        'Attractions',
                                        Icons.beach_access_rounded,
                                        const Color.fromARGB(
                                            255, 109, 206, 160), () {
                                      Navigator.pushNamed(
                                          context, CustomRouter.placeList);
                                    }),
                                    gapWidth8,
                                    _buildCategoryCard(
                                        'Activities',
                                        Icons.sports_cricket,
                                        const Color.fromARGB(
                                            255, 245, 120, 120), () {
                                      Navigator.pushNamed(
                                          context, CustomRouter.activityList);
                                    }),
                                  ],
                                ),
                                gapHeight24,
                                _buildSectionTitle('Popular Destinations', () {
                                  Navigator.pushNamed(
                                      context, CustomRouter.placeList);
                                }),
                                gapHeight8,
                                _buildAttractionSection(places),
                                gapHeight36,
                                _buildSectionTitle('Food Recommendations', () {
                                  Navigator.pushNamed(
                                      context, CustomRouter.foodList);
                                }),
                                gapHeight8,
                                _buildGridSection(foodList),
                                gapHeight8,
                                const Divider(),
                                gapHeight24,
                                _buildSectionTitle('Top-Pick Activities', () {
                                  Navigator.pushNamed(
                                      context, CustomRouter.activityList);
                                }),
                                gapHeight8,
                                _buildGeneralSection(activities),
                                gapHeight16,
                              ],
                            ),
                          );
                        });
                  });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      String name, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: AppBorder.cardBorder,
          boxShadow: [
            BoxShadow(
              color: AppColor.labelGray.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(4, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24.w,
                child: Icon(
                  icon,
                  size: 28.w,
                  color: color,
                )),
            SizedBox(height: 10.h),
            Text(
              name,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onTap) {
    return Row(
      children: [
        Text(title, style: AppTextStyle.header2),
        const Spacer(),
        AppTextButton(title: 'View More', onTap: onTap)
      ],
    );
  }

  Widget _buildAttractionSection(List<PlaceData> places) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: places.length > 4 ? 4 : places.length,
        itemBuilder: (context, index) {
          final attraction = places[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, CustomRouter.placeDetail,
                  arguments: PlaceDetailPage(placeID: attraction.placeID));
            },
            child: Container(
              width: 210,
              margin: EdgeInsets.only(right: 16.w),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: AppBorder.cardBorder,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        child: Image.network(
                          attraction.image,
                          width: double.infinity,
                          height: 200.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 4.h,
                        left: 4.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            attraction.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGeneralSection(List<ActivityData> activities) {
    return SizedBox(
      height: 300.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: activities.length > 4 ? 4 : activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, CustomRouter.activityDetail,
                  arguments: ActivityDetailPage(
                    activityID: activity.activityID,
                  ));
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.70,
              margin: EdgeInsets.only(right: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppBorder.cardBorder,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(4.r)),
                          child: Image.network(
                            activity.photoUrls[0],
                            width: double.infinity,
                            height: 200.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GeneralItemInfo(
                      name: activity.businessName,
                      location: activity.address,
                      rating: activity.averageRating,
                      review: activity.ratingCount)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridSection(List<FoodData> foodList) {
    return SizedBox(
      height: foodList.length > 2 ? 600.h : 300.h,
      child: FoodGridView(
        foodList: foodList,
        itemLength: foodList.length > 4 ? 4 : foodList.length,
        physics: const NeverScrollableScrollPhysics(),
        onItemTap: (food) {
          Navigator.pushNamed(context, CustomRouter.foodDetail,
              arguments: FoodDetailPage(foodID: food.foodID));
        },
      ),
    );
  }
}
