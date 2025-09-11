import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imagePaths;

  const ImageSlider({
    super.key,
    this.imagePaths = const [
      'assets/images/slider_image.png',
      'assets/images/slider_image.png',
      'assets/images/slider_image.png',
    ],
  });

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < widget.imagePaths.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 140.h,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imagePaths.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    widget.imagePaths[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 8.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imagePaths.length, (index) {
              final bool isActive = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: isActive ? 35.w : 30.w,
                height:  isActive ? 12.h : 6.h,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFBA1B1B)
                      : const Color(0xFFAFAFAF),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
