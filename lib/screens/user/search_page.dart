import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/utils/state_provider.dart/food_state.dart';
import 'package:go_perak/utils/state_provider.dart/place_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Search extends HookConsumerWidget {
  Search({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchValueNotifier = useState('');
    final textEditController = useTextEditingController();

    // Fetch category lists
    final foodListAsync = ref.watch(foodListProvider);
    final activityListAsync = ref.watch(activityListProvider);
    final attractionListAsync = ref.watch(placesProvider);

    useEffect(() {
      void listener() {
        searchValueNotifier.value =
            textEditController.text.toLowerCase().trim();
      }

      textEditController.addListener(listener);
      return () => textEditController.removeListener(listener);
    }, [textEditController]);

    // Combine all lists (Food, Attractions, and Activities)
    final combinedList = [
      ...?foodListAsync.value,
      ...?activityListAsync.value,
      ...?attractionListAsync.value,
    ];

    // Filter the combined list based on the search term
    // final filteredList = combinedList.where((item) {
    //   return item.name?.toLowerCase().contains(searchValueNotifier.value) ??
    //       false;
    // }).toList();

    return SafeArea(child: Scaffold());
    // child: Scaffold(
    //   backgroundColor: Colors.white,
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar(
    //         expandedHeight: 80,
    //         backgroundColor: Colors.white,
    //         leading: Container(),
    //         actions: [],
    //         floating: true,
    //         flexibleSpace: FlexibleSpaceBar(
    //           background: Container(
    //             margin: const EdgeInsets.all(8),
    //             child: TextField(
    //               controller: textEditController,
    //               decoration: InputDecoration(
    //                 contentPadding:
    //                     EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
    //                 hintText: "Where to?",
    //                 prefixIcon:
    //                     const Icon(Icons.search, color: Colors.black54),
    //                 filled: true,
    //                 fillColor: Colors.white,
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(30),
    //                   borderSide: const BorderSide(color: Colors.black),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //       SliverPadding(
    //         padding: const EdgeInsets.all(8.0),
    //         sliver: searchValueNotifier.value.isEmpty
    //             ? SliverFillRemaining(
    //                 child: Column(
    //                   children: [
    // ListTile(
    //   leading: const Icon(Icons.ramen_dining),
    //   title: const Text('Food'),
    //   onTap: () {
    //     // Navigate to the Food category page
    //   },
    // ),
    // ListTile(
    //   leading: const Icon(Icons.location_on),
    //   title: const Text('Attractions'),
    //   onTap: () {
    //     // Navigate to the Attractions category page
    //   },
    // ),
    // ListTile(
    //   leading: const Icon(Icons.directions_run),
    //   title: const Text('Activities'),
    //   onTap: () {
    //     // Navigate to the Activities category page
    //   },
    // ),
    //                   ],
    //                 ),
    //               )
    //             : filteredList.isEmpty
    //                 ? const SliverFillRemaining(
    //                     child: Center(child: Text('No result found')),
    //                   )
    //                 : SliverList(
    //                     delegate: SliverChildBuilderDelegate(
    //                       (context, index) {
    //                         final item = filteredList[index];
    //                         return GestureDetector(
    //                           onTap: () => Navigator.pushNamed(
    //                               context, CustomRouter.placeDetail),
    //                           child: Container(
    //                             padding: const EdgeInsets.all(8.0),
    //                             margin: const EdgeInsets.only(bottom: 16.0),
    //                             child: Row(
    //                               crossAxisAlignment:
    //                                   CrossAxisAlignment.start,
    //                               children: [
    //                                 ClipRRect(
    //                                   borderRadius: BorderRadius.circular(4),
    //                                   child: Image.asset(
    //                                     item.image ?? '',
    //                                     width: 130,
    //                                     height: 130,
    //                                     fit: BoxFit.cover,
    //                                     errorBuilder: (_, __, ___) =>
    //                                         const Icon(Icons.broken_image),
    //                                   ),
    //                                 ),
    //                                 const SizedBox(width: 12),
    //                                 Expanded(
    //                                   child: Padding(
    //                                     padding: const EdgeInsets.fromLTRB(
    //                                         0, 50, 0, 0),
    //                                     child: Column(
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                       children: [
    //                                         Text(item.name ?? '',
    //                                             style: AppTextStyle.header2),
    //                                         Text(item.location ?? '',
    //                                             style:
    //                                                 AppTextStyle.description),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                       childCount: filteredList.length,
    //                     ),
    //                   ),
    //       ),
    //     ],
    //   ),
    // ),
  }
}
