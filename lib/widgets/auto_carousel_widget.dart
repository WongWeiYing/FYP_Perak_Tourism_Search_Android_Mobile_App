import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_perak/screens/user/full_screen_page.dart';

// class AutoCarousel extends StatefulWidget {
//   final List<String> images;

//   const AutoCarousel({Key? key, required this.images}) : super(key: key);

//   @override
//   State<AutoCarousel> createState() => _AutoCarouselState();
// }

// class _AutoCarouselState extends State<AutoCarousel> {
//   late final PageController _pageController;
//   late Timer _timer;
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();

//     _timer = Timer.periodic(const Duration(seconds: 8), (Timer timer) {
//       if (!mounted) return;
//       if (_currentPage < widget.images.length - 1) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }

//       _pageController.animateToPage(
//         _currentPage,
//         duration: const Duration(seconds: 1000),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PageView.builder(
//       controller: _pageController,
//       itemCount: widget.images.length,
//       itemBuilder: (context, index) {
//         return Image.network(
//           widget.images[index],
//           fit: BoxFit.cover,
//           width: double.infinity,
//         );
//       },
//     );
//   }
// }

class AutoCarousel extends StatefulWidget {
  final List<String> images;

  const AutoCarousel({Key? key, required this.images}) : super(key: key);

  @override
  State<AutoCarousel> createState() => _AutoCarouselState();
}

class _AutoCarouselState extends State<AutoCarousel> {
  late final PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 8), (Timer timer) {
      if (!mounted) return;
      if (_currentPage < widget.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(
            milliseconds: 500), // Reduced from 1000 seconds to 0.5s
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.images.length,
      onPageChanged: (index) {
        _currentPage = index;
      },
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImagePage(
                  imageUrls: widget.images,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: Image.network(
            widget.images[index],
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        );
      },
    );
  }
}
