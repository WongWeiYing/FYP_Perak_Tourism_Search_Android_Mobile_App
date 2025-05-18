import 'package:flutter/material.dart';

class PhotosGridView extends StatelessWidget {
  final List<String> photosUrls;

  const PhotosGridView({
    super.key,
    required this.photosUrls,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photosUrls.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Image.network(
              photosUrls[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ],
        );
      },
    );
  }
}
