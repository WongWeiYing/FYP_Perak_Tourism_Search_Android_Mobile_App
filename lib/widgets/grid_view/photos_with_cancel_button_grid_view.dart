import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_perak/widgets/button/cancel_photo_button.dart';

class PhotoGridView extends StatelessWidget {
  final List<File> photos;
  final void Function(int index) onRemove;

  const PhotoGridView({
    super.key,
    required this.photos,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Image.file(
              photos[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            CancelPhotoButton(
              onTap: () => onRemove(index),
            ),
          ],
        );
      },
    );
  }
}
