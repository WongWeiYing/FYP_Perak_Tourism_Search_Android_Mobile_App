import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/data/user_data.dart';
import 'package:go_perak/repositories/update_repo.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> showImageSourceActionSheet(
    BuildContext context, WidgetRef ref) async {
  final picker = ImagePicker();

  // final userID = ref.watch(userIDProvider);
  final userDetails = ref.watch(userDetailsProvider);

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
            height: 150.h,
            child: Column(
              children: [
                gapHeight24,
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: const Text(
                      'Take photo',
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      print('Image: $image');
                      if (image != null) {
                        updateProfilePic(image, userDetails.value!, ref);
                      }
                    },
                  ),
                ),
                gapHeight12,
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
                      Navigator.pop(context); // close the sheet
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        await updateProfilePic(image, userDetails.value!, ref);
                      }
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

Future<void> updateProfilePic(
    XFile picXFile, UserData userData, WidgetRef ref) async {
  ref.read(profilePicUploadingProvider.notifier).state = true;
  print('Enter update profile function');
  String picFilePath;

  File picFile = File(picXFile.path);
  final supabase = Supabase.instance.client;
  final picFileExt = picFile.path.split('.').last;
  picFilePath = 'profile-pictures/${userData.userID}/profile.$picFileExt';

  final res = await supabase.storage.from('profile-pictures').upload(
        picFilePath,
        picFile,
        fileOptions: const FileOptions(upsert: true),
      );

  if (res.isNotEmpty) {
    String newProfilePic =
        supabase.storage.from("profile-pictures").getPublicUrl(picFilePath);

    String updatedProfilePicUrl =
        '$newProfilePic?version=${DateTime.now().millisecondsSinceEpoch}';

    UpdateRepo updateRepo = UpdateRepo();
    updateRepo.updateInfo(
        'Users', userData.userID, 'profilePic', updatedProfilePicUrl, null);
    updateRepo.updateMultipleRecords('Ratings', 'userID', userData.userID,
        'profilePic', updatedProfilePicUrl);
  }

  ref.invalidate(userDetailsProvider);

  ref.read(profilePicUploadingProvider.notifier).state = false;
}
