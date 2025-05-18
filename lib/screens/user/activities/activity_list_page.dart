import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/screens/user/activities/activity_detail_page.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/widgets/bar/app_bar.dart';
import 'package:go_perak/widgets/button/wishlist_button.dart';
import 'package:go_perak/widgets/drawer.dart';
import 'package:go_perak/widgets/general_item_info.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class ActivityListPage extends HookConsumerWidget {
  ActivityListPage({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState<String>('');

    final tags = useState<Set<String>>({});
    final sortType = useState<String?>(null);
    final low = useState<int>(0);
    final high = useState<int>(5);

    final tempTags = useState<Set<String>>({...tags.value});
    final tempSort = useState<String?>(sortType.value);
    final tempLow = useState<int>(low.value);
    final tempHigh = useState<int>(high.value);

    final controller = useTextEditingController();

    final activityListAsync = ref.watch(activityListProvider);

    return activityListAsync.when(
      data: (data) {
        final filteredactivityList = data.where((activity) {
          final matchesSearch = activity.businessName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

          final matchesRating = activity.averageRating >= low.value &&
              activity.averageRating <= high.value;

          final matchesTag =
              tags.value.every((tag) => activity.tags.contains(tag));

          return matchesSearch && matchesRating && matchesTag;
        }).toList();

        if (sortType.value == 'Highest Reviews') {
          filteredactivityList
              .sort((a, b) => b.ratingCount.compareTo(a.ratingCount));
        } else if (sortType.value == 'Lowest Reviews') {
          filteredactivityList
              .sort((a, b) => a.ratingCount.compareTo(b.ratingCount));
        } else if (sortType.value == 'Highest Rating') {
          filteredactivityList
              .sort((a, b) => b.averageRating.compareTo(a.averageRating));
        } else if (sortType.value == 'Lowest Rating') {
          filteredactivityList
              .sort((a, b) => a.averageRating.compareTo(b.averageRating));
        }

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: ProjectAppBar(
            title: 'Activities',
            actions: [
              IconButton(
                onPressed: () {
                  scaffoldKey.currentState?.openEndDrawer();
                },
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),
          endDrawer: AppDrawer(
            type: 'Activities',
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
                padding: EdgeInsets.all(4),
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
              if (filteredactivityList.isEmpty)
                Center(
                  child: Lottie.asset(
                      'assets/animations/empty_list_animation.json',
                      width: 200.w,
                      height: 200.h),
                ),
              Expanded(
                  child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: filteredactivityList.length,
                itemBuilder: (context, index) {
                  final activity = filteredactivityList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, CustomRouter.activityDetail,
                          arguments: ActivityDetailPage(
                              activityID: activity.activityID));
                    },
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                activity.photoUrls[0],
                                width: 130.w,
                                height: 130.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: SavelistButton(
                                itemID: activity.activityID,
                                type: 'Activities',
                              ),
                            ),
                          ],
                        ),
                        gapWidth12,
                        Expanded(
                          child: GeneralItemInfo(
                            name: activity.businessName,
                            location: activity.address,
                            rating: activity.averageRating,
                            review: activity.ratingCount,
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return gapHeight24;
                },
              )),
            ],
          ),
        );
      },
      loading: () => Center(child: showLoading()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
