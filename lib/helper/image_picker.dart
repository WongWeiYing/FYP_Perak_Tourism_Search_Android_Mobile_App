import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromGallery() async {
  try {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
  } catch (e) {
    print('Error picking image: $e');
  }
  return null;
}

Future<List<File>> pickMultipleImagesFromGallery() async {
  try {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      return pickedFiles.map((file) => File(file.path)).toList();
    }
  } catch (e) {
    print('Error picking images: $e');
  }
  return [];
}
