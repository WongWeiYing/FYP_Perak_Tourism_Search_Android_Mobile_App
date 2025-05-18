import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/screens/user/activities/activity_detail_page.dart';
import 'package:go_perak/screens/user/food/food_detail_page.dart';
import 'package:go_perak/screens/user/places/place_detail_page.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/utils/state_provider.dart/food_state.dart';
import 'package:go_perak/utils/state_provider.dart/place_state.dart';
import 'package:go_perak/widgets/bar/app_bottom_nav_bar.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExploreSearchPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState('');

    final foodAsync = ref.watch(foodListProvider);
    final activityAsync = ref.watch(activityListProvider);
    final placeAsync = ref.watch(placesProvider);

    final controller = useTextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const ProjectAppBottomNav(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controller,
              onChanged: (value) => searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'Search food, activities, places...',
                border: const OutlineInputBorder(),
                suffixIcon: searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          controller.clear();
                          searchQuery.value = '';
                        },
                      )
                    : const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: foodAsync.when(
              data: (foods) => activityAsync.when(
                data: (activities) => placeAsync.when(
                  data: (places) {
                    final query = searchQuery.value.toLowerCase();

                    final matchedFoods = foods
                        .where(
                            (f) => f.businessName.toLowerCase().contains(query))
                        .toList();
                    final matchedActivities = activities
                        .where(
                            (a) => a.businessName.toLowerCase().contains(query))
                        .toList();
                    final matchedPlaces = places
                        .where((p) => p.name.toLowerCase().contains(query))
                        .toList();

                    return ListView(
                      children: [
                        if (searchQuery.value.isEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Food',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          ...foods.take(4).map((f) => ListTile(
                                title: Text(f.businessName),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, CustomRouter.foodDetail,
                                      arguments:
                                          FoodDetailPage(foodID: f.foodID));
                                },
                              )),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Attractions',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          ...places.take(4).map((p) => ListTile(
                                title: Text(p.name),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, CustomRouter.placeDetail,
                                      arguments: PlaceDetailPage(
                                        placeID: p.placeID,
                                      ));
                                },
                              )),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Activities',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          ...activities.take(4).map((a) => ListTile(
                                title: Text(a.businessName),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, CustomRouter.activityDetail,
                                      arguments: ActivityDetailPage(
                                          activityID: a.activityID));
                                },
                              ))
                        ],
                        if (searchQuery.value.isNotEmpty) ...[
                          if (matchedFoods.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Foods',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            ...matchedFoods.map((f) => searchResult(
                                    f.photoUrls[0], f.businessName, () {
                                  Navigator.pushNamed(
                                      context, CustomRouter.foodDetail,
                                      arguments:
                                          FoodDetailPage(foodID: f.foodID));
                                })),
                          ],
                          if (matchedPlaces.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Places',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            ...matchedPlaces
                                .map((p) => searchResult(p.image, p.name, () {
                                      Navigator.pushNamed(
                                          context, CustomRouter.placeDetail,
                                          arguments: PlaceDetailPage(
                                            placeID: p.placeID,
                                          ));
                                    })),
                          ],
                          if (matchedActivities.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Activities',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            ...matchedActivities.map((a) => searchResult(
                                    a.photoUrls[0], a.businessName, () {
                                  Navigator.pushNamed(
                                      context, CustomRouter.activityDetail,
                                      arguments: ActivityDetailPage(
                                          activityID: a.activityID));
                                })),
                          ],
                          if (matchedFoods.isEmpty &&
                              matchedActivities.isEmpty &&
                              matchedPlaces.isEmpty)
                            const Center(child: Text("No results found.")),
                        ]
                      ],
                    );
                  },
                  loading: () => Center(child: showLoading()),
                  error: (err, _) =>
                      Center(child: Text("Error loading places")),
                ),
                loading: () => Center(child: showLoading()),
                error: (err, _) =>
                    Center(child: Text("Error loading activities")),
              ),
              loading: () => Center(child: showLoading()),
              error: (err, _) => Center(child: Text("Error loading foods")),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchResult(String photoUrl, String name, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(children: [
        gapWidth8,
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Image.network(
            photoUrl,
            width: 130.w,
            height: 130.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, size: 130);
            },
          ),
        ),
        gapWidth12,
        Text(
          name,
          style: AppTextStyle.header2,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ]),
    );
  }
}
