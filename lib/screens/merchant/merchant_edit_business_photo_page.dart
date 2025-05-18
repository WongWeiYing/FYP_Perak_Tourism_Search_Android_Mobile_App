// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:go_perak/constants/app_spacing.dart';
// import 'package:go_perak/screens/merchant/merchant_edit_business_detail_page.dart';
// import 'package:go_perak/widgets/button/primary_button.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class MerchantEditBusinessPhotoPage extends HookConsumerWidget {
//   final List<String> photoUrls;

//   const MerchantEditBusinessPhotoPage({super.key, required this.photoUrls});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final photos = useState<List<String>>(photoUrls);
//     //final newPhotos = useState<List<String>>([]);

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Business Photos'),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: List.generate(photos.value.length, (index) {
//                   return Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: SizedBox(
//                           width: 130,
//                           height: 130,
//                           child: Image.network(
//                             photos.value[index],
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 4,
//                         right: 4,
//                         child: GestureDetector(
//                           onTap: () {
//                             photos.value = List.from(photos.value)
//                               ..removeAt(index);
//                           },
//                           child: const Icon(Icons.close, color: Colors.red),
//                         ),
//                       )
//                     ],
//                   );
//                 }),
//               ),

//               const SizedBox(height: 16),

//                Row(
//                 children: [
//                   const Expanded(
//                       child: MerchantContainer(data: 'Select from gallery')),
//                   gapWidth8,
//                   const Expanded(child: MerchantContainer(data: 'Take photo')),
//                 ],
//               ),

//               const SizedBox(height: 32),

//               Center(
//                 child: PrimaryButton(
//                   title: 'Done',
//                   onTap: () {
//                     // Handle submission
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
