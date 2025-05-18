import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/screens/user/places/place_detail_page.dart';
import 'package:go_perak/utils/state_provider.dart/place_state.dart';
import 'package:go_perak/widgets/bar/app_bar.dart';
import 'package:go_perak/widgets/button/wishlist_button.dart';
import 'package:go_perak/widgets/drawer.dart';
import 'package:go_perak/widgets/general_item_info.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class PlaceListPage extends HookConsumerWidget {
  PlaceListPage({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState<String>('');
    //final selectedRating = useState<int?>(null);
    // final low = useState<int>(0);
    // final high = useState<int>(5);
    // final sortType = useState<String?>(null); // null means no filter

    final tags = useState<Set<String>>({});
    final sortType = useState<String?>(null);
    final low = useState<int>(0);
    final high = useState<int>(5);

    final tempTags = useState<Set<String>>({...tags.value});
    final tempSort = useState<String?>(sortType.value);
    final tempLow = useState<int>(low.value);
    final tempHigh = useState<int>(high.value);

    final placesAsync = ref.watch(placesProvider);

    final controller = useTextEditingController();

    return placesAsync.when(
      data: (data) {
        final filteredPlaces = data.where((place) {
          final matchesSearch = place.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());
          final matchesRating = place.averageRating >= low.value &&
              place.averageRating <= high.value;

          return matchesSearch && matchesRating;
        }).toList();

        if (sortType.value == 'Highest Reviews') {
          filteredPlaces.sort((a, b) => b.ratingCount.compareTo(a.ratingCount));
        } else if (sortType.value == 'Lowest Reviews') {
          filteredPlaces.sort((a, b) => a.ratingCount.compareTo(b.ratingCount));
        }

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: ProjectAppBar(
            title: 'Beautiful Places',
            actions: [
              gapWidth4,
              IconButton(
                onPressed: () {
                  scaffoldKey.currentState?.openEndDrawer();
                },
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),
          endDrawer: AppDrawer(
            type: 'Places',
            selectedTags: tempTags.value,
            selectedSort: tempSort.value,
            selectedLow: tempLow.value,
            selectedHigh: tempHigh.value,
            onTagToggle: (tag) {
              if (tempTags.value.contains(tag)) {
                tempTags.value = {...tempTags.value}..remove(tag);
              } else {
                tempTags.value = {...tempTags.value, tag};
              }
            },
            onSortSelected: (sort) => tempSort.value = sort,
            onRatingSelected: (l, h) {
              tempLow.value = l;
              tempHigh.value = h;
            },
            onApply: () {
              tags.value = {...tempTags.value};
              sortType.value = tempSort.value;
              low.value = tempLow.value;
              high.value = tempHigh.value;
              scaffoldKey.currentState?.closeEndDrawer();
            },
            onReset: () {
              tags.value = {};
              sortType.value = null;
              low.value = 0;
              high.value = 5;
              scaffoldKey.currentState?.closeEndDrawer();
            },
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
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
              if (filteredPlaces.isEmpty)
                Center(
                  child: Lottie.asset(
                      'assets/animations/empty_list_animation.json',
                      width: 200.w,
                      height: 200.h),
                ),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredPlaces.length,
                  itemBuilder: (context, index) {
                    final place = filteredPlaces[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, CustomRouter.placeDetail,
                            arguments: PlaceDetailPage(placeID: place.placeID));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.r)),
                                  child: Image.network(
                                    place.image,
                                    width: double.infinity,
                                    height: 200.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: SavelistButton(
                                    itemID: place.placeID,
                                    type: 'Places',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GeneralItemInfo(
                            name: place.name,
                            location: place.address,
                            rating: place.averageRating,
                            review: place.ratingCount,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return gapHeight24;
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Lottie.asset(
            'assets/animations/loading_animation.json',
            width: 200.w,
            height: 200.h,
          ),
        ),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
