import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/repositories/update_repo.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/utils/state_provider.dart/food_state.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> showMerchantImageSourceActionSheet(
    BuildContext context,
    WidgetRef ref,
    List<String> oldPhotoUrls,
    String categoryType,
    String businessID) async {
  final picker = ImagePicker();

  final currentUser = ref.watch(currentUserProvider);

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 120.h,
            child: Column(
              children: [
                gapHeight24,
                Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.image_outlined),
                    title: const Text(
                      'Choose from gallery',
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final List<XFile> image = await picker.pickMultiImage();

                      ref.read(uploadingProvider.notifier).state = true;

                      await updateBusinessPhotos(context, currentUser.userID!,
                          businessID, oldPhotoUrls, image, categoryType);

                      if (categoryType == 'Food') {
                        ref.invalidate(foodProvider(businessID));
                      } else {
                        ref.invalidate(activityProvider(businessID));
                      }

                      ref.read(uploadingProvider.notifier).state = false;
                    },
                  ),
                ),
                gapWidth24
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> updateBusinessPhotos(
    BuildContext context,
    String docID,
    String businessID,
    List<String> oldPhotoUrls,
    List<XFile> newPhotoUrls,
    String categoryType) async {
  final supabase = Supabase.instance.client;

  print(oldPhotoUrls);

  List<String> fileNames =
      oldPhotoUrls.map((url) => url.split('/').last).toList();

  print(fileNames);
  print(docID);

  final fullPaths =
      fileNames.map((name) => 'business-photos/$docID/$name').toList();

  await supabase.storage.from('business-photos').remove(fullPaths);

  List<String> photoUrls = [];
  for (var image in newPhotoUrls) {
    File imageFile = File(image.path);
    final ext = imageFile.path.split('.').last;
    final filePath =
        'business-photos/$docID/${DateTime.now().millisecondsSinceEpoch}.$ext';
    final res = await supabase.storage
        .from('business-photos')
        .upload(filePath, imageFile);
    if (res.isNotEmpty) {
      final url =
          supabase.storage.from('business-photos').getPublicUrl(filePath);
      photoUrls.add(url);
    }
    UpdateRepo updateRepo = UpdateRepo();
    await updateRepo.updateInfo(
        categoryType, businessID, 'photoUrls', null, photoUrls);
  }
}
