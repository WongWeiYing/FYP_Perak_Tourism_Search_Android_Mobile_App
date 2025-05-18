import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/widgets/button/primary_button.dart';

// class AppDrawer extends StatelessWidget {
//   final void Function(String)? onItemSelected;
//   final String? type;

//   const AppDrawer({super.key, this.onItemSelected, this.type});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             Text(
//               'Search Filter',
//               style: AppTextStyle.bodyText,
//             ),
//             gapHeight16,
//             _buildSectionTitle('Ratings'),
//             // _buildOptionGrid(
//             //     ['5 Stars', '4 Stars', '3 Stars', '2 Stars', '1 Star', 'All']),
//             _buildOptionGrid([
//               '4 - 5 Rate',
//               '3 - 4 Rate',
//               '2 - 3 Rate',
//               '1 - 2 Rate',
//               '0 - 1 Rate',
//               'All'
//             ]),
//             gapHeight16,
//             if (type == 'Food') ...[
//               _buildSectionTitle('Tags'),
//               _buildOptionGrid([
//                 "Western",
//                 "Malay",
//                 "Chinese",
//                 "Indian",
//                 "Mamak",
//                 "Local",
//                 "Dessert"
//               ])
//             ],
//             if (type == 'Activities') ...[
//               _buildSectionTitle('Tags'),
//               _buildOptionGrid([
//                 'Hiking',
//                 'Swimming',
//                 'Cycling',
//                 'Camping',
//                 'Fishing',
//                 'Sightseeing'
//               ])
//             ],

//             gapHeight16,
//             _buildSectionTitle('Reviews'),
//             _buildOptionGrid(['Highest Reviews', 'Lowest Reviews']),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Text(
//         title,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _buildOptionGrid(List<String> options) {
//     return GridView.count(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisSpacing: 8,
//       mainAxisSpacing: 8,
//       childAspectRatio: 3.5,
//       children: options
//           .map((option) => OutlinedButton(
//                 onPressed: () => onItemSelected?.call(option),
//                 style: OutlinedButton.styleFrom(
//                   backgroundColor: Colors.grey.shade100,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   option,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(color: Colors.black, fontSize: 12),
//                 ),
//               ))
//           .toList(),
//     );
//   }
// }

class AppDrawer extends StatelessWidget {
  final void Function()? onApply;
  final Set<String> selectedTags;
  final String? selectedSort;
  final int selectedLow;
  final int selectedHigh;
  final Function(String tag) onTagToggle;
  final Function(String sort) onSortSelected;
  final Function(int low, int high) onRatingSelected;
  final void Function()? onReset;

  final String? type;

  const AppDrawer({
    super.key,
    this.onApply,
    this.onReset,
    required this.selectedTags,
    required this.selectedSort,
    required this.selectedLow,
    required this.selectedHigh,
    required this.onTagToggle,
    required this.onSortSelected,
    required this.onRatingSelected,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Search Filter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            gapHeight16,
            _buildSectionTitle('Ratings'),
            _buildOptionGrid(
              [
                '4 - 5 Rate',
                '3 - 4 Rate',
                '2 - 3 Rate',
                '1 - 2 Rate',
                '0 - 1 Rate',
                'All'
              ],
              (opt) {
                switch (opt) {
                  case '0 - 1 Rate':
                    onRatingSelected(0, 1);
                    break;
                  case '1 - 2 Rate':
                    onRatingSelected(1, 2);
                    break;
                  case '2 - 3 Rate':
                    onRatingSelected(2, 3);
                    break;
                  case '3 - 4 Rate':
                    onRatingSelected(3, 4);
                    break;
                  case '4 - 5 Rate':
                    onRatingSelected(4, 5);
                    break;
                  case 'All':
                    onRatingSelected(0, 5);
                    break;
                }
              },
              isSelected: (opt) {
                final ratingMap = {
                  '0 - 1 Rate': [0, 1],
                  '1 - 2 Rate': [1, 2],
                  '2 - 3 Rate': [2, 3],
                  '3 - 4 Rate': [3, 4],
                  '4 - 5 Rate': [4, 5],
                  'All': [0, 5],
                };
                return ratingMap[opt]![0] == selectedLow &&
                    ratingMap[opt]![1] == selectedHigh;
              },
            ),
            gapHeight16,
            if (type == 'Food' || type == 'Activities') ...[
              _buildSectionTitle('Tags'),
              _buildOptionGrid(
                type == 'Food'
                    ? [
                        "Western",
                        "Malay",
                        "Chinese",
                        "Indian",
                        "Mamak",
                        "Local",
                        "Dessert"
                      ]
                    : [
                        'Hiking',
                        'Swimming',
                        'Cycling',
                        'Camping',
                        'Fishing',
                        'Sightseeing'
                      ],
                onTagToggle,
                isSelected: selectedTags.contains,
                multiSelect: true,
              )
            ],
            gapHeight16,
            _buildSectionTitle('Reviews & Ratings Sort'),
            _buildOptionGrid(
              [
                'Highest Reviews',
                'Lowest Reviews',
                'Highest Rating',
                'Lowest Rating'
              ],
              onSortSelected,
              isSelected: (val) => val == selectedSort,
            ),
            gapHeight24,
            PrimaryButton(
              height: 35.h,
              onTap: onApply,
              title: 'Apply Filters',
            ),
            gapHeight24,
            PrimaryButton(
              height: 35.h,
              onTap: onReset,
              title: 'Reset Filters',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOptionGrid(
    List<String> options,
    Function(String option) onPressed, {
    required bool Function(String) isSelected,
    bool multiSelect = false,
  }) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 3.5,
      children: options.map((option) {
        final selected = isSelected(option);
        return OutlinedButton(
          onPressed: () => onPressed(option),
          style: OutlinedButton.styleFrom(
            backgroundColor: selected
                ? AppColor.primaryColor.withOpacity(0.2)
                : Colors.grey.shade100,
            side: BorderSide(
                color: selected
                    ? AppColor.primaryColor.withOpacity(0.2)
                    : Colors.grey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(option,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColor.black)),
        );
      }).toList(),
    );
  }
}
