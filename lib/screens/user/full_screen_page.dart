import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImagePage({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: InteractiveViewer(
            child: PageView.builder(
              itemCount: imageUrls.length,
              controller: PageController(initialPage: initialIndex),
              itemBuilder: (context, index) {
                return Center(
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.contain, // This ensures the image fits well
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
