import 'dart:async';
import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/langCode.dart';

class BannerModel {
  final int id;
  final String image;
  final String link;

  BannerModel({required this.id, required this.image, required this.link});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'],
      link: json['link'],
    );
  }
}

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  List<BannerModel> banners = [];
  bool isLoading = true;

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      final response = await _dio.get(
        "$mainApi/app/elwarsha/banners/get",
        options: Options(headers: {"Accept": "application/json",  "Accept-Language": langCode == '' ? "en" : langCode}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> bannerList = response.data["data"];

        setState(() {
          banners = bannerList.map((e) => BannerModel.fromJson(e)).toList();
          isLoading = false;
        });

        if (banners.isNotEmpty) {
          _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
            if (_currentIndex < banners.length - 1) {
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
      }
    } catch (e) {
      debugPrint("Error fetching banners: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 140.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (banners.isEmpty) {
      return const Center(child: Text("No banners available"));
    }

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
                itemCount: banners.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return GestureDetector(
                    onTap: () {
                      debugPrint("Open link: ${banner.link}");
                    },
                    child: Image.network(
                      banner.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image));
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 8.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (index) {
              final bool isActive = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: isActive ? 35.w : 30.w,
                height: isActive ? 12.h : 6.h,
                decoration: BoxDecoration(
                  color:
                      isActive
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
