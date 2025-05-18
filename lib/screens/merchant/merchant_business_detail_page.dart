import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/data/food_activity_data.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/utils/state_provider.dart/food_state.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// class MerchantBusinessDetailPage extends StatefulHookConsumerWidget {
//   final String businessType;
//   final String businessID;
//   const MerchantBusinessDetailPage(
//       {super.key, required this.businessType, required this.businessID});

//   @override
//   MerchantBusinessDetailPageState createState() =>
//       MerchantBusinessDetailPageState();
// }

// class MerchantBusinessDetailPageState
//     extends ConsumerState<MerchantBusinessDetailPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final AsyncValue<FoodActivityDataBase> businessDetail =
//         widget.businessType == 'Food'
//             ? ref.watch(foodProvider(widget.businessID))
//             : ref.watch(activityProvider(widget.businessID));

//     return businessDetail.when(
//       data: (data) {
//         return Scaffold(
//           backgroundColor: Colors.white,
//           body: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 gapHeight12,
//                 Text(
//                   'Description',
//                   style: AppTextStyle.header3,
//                 ),
//                 gapHeight8,
//                 MerchantContainer(data: data.description),
//                 gapHeight24,
//                 Text(
//                   'Category',
//                   style: AppTextStyle.header3,
//                 ),
//                 gapHeight8,
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 12,
//                   children: data.tags.map((tag) {
//                     return Chip(
//                       label: Text(tag),
//                       backgroundColor: const Color.fromARGB(255, 254, 255, 255),
//                       labelStyle: const TextStyle(color: Colors.black),
//                     );
//                   }).toList(),
//                 ),
//                 gapHeight24,
//                 Text('Operating Hours', style: AppTextStyle.header3),
//                 gapHeight8,
//                 MerchantContainer(data: data.operatingHours),
//                 gapHeight24,
//                 Text('Contact Information', style: AppTextStyle.header3),
//                 gapHeight8,
//                 MerchantContainer(
//                   widget: Row(
//                     children: [
//                       const Icon(
//                         Icons.email_outlined,
//                       ),
//                       gapWidth12,
//                       Text(data.businessEmail, style: AppTextStyle.bodyText),
//                     ],
//                   ),
//                 ),
//                 gapHeight4,
//                 MerchantContainer(
//                   widget: Row(
//                     children: [
//                       const Icon(
//                         Icons.phone_outlined,
//                       ),
//                       gapWidth12,
//                       Text(data.contactNumber, style: AppTextStyle.bodyText),
//                     ],
//                   ),
//                 ),
//                 gapHeight16,
//                 Text('Location', style: AppTextStyle.header3),
//                 gapHeight8,
//                 MerchantContainer(
//                   data: data.address,
//                 ),
//                 gapHeight16,
//                 Text('Photos', style: AppTextStyle.header3),
//                 gapHeight8,
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   padding: const EdgeInsets.all(8),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                   ),
//                   itemCount: data.photoUrls.length,
//                   itemBuilder: (context, index) {
//                     return Stack(
//                       children: [
//                         Image.network(
//                           data.photoUrls[index],
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity,
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 gapHeight32,
//               ],
//             ),
//           ),
//         );
//       },
//       loading: () => Center(child: showLoading()),
//       error: (err, stack) {
//         return Center(child: Text(stack.toString()));
//       },
//     );
//   }
// }

// class MerchantContainer extends StatelessWidget {
//   final String? data;
//   final Widget? widget;
//   const MerchantContainer({
//     this.data,
//     this.widget,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(
//             color: const Color.fromARGB(
//                 255, 235, 233, 233)), // You can change the color
//         borderRadius: BorderRadius.circular(8), // Optional: rounded corners
//       ),
//       child: widget ??
//           Text(
//             data ?? '',
//             style: AppTextStyle.bodyText,
//           ),
//     );
//   }
// }
