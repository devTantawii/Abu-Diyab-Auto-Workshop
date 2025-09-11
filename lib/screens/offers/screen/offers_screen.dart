import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isArabic = locale.isDirectionRTL(context);

    return Scaffold(
      backgroundColor:Theme.of(context).brightness == Brightness.light
          ? Colors. white
          : Colors. black,
      appBar: AppBar(
        toolbarHeight: 100.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          height: 130.h,
          padding: EdgeInsets.only(top: 20.h, right: 16.w, left: 16.w),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFBA1B1B), Color(0xFFD27A7A)],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isArabic ? 'العروض' : 'Offers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body:
      Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              decoration: BoxDecoration(
                color:    Theme.of(context).brightness == Brightness.light
                    ? Colors. white
                    : Colors. black,
                border: Border.all(color: const Color(0xFFAFAFAF)),
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12.r,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      'assets/images/slider_image.png',
                      width: double.infinity,
                      height: 140.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          isArabic
                              ? 'صلح سيارتك الحين وادفع بعدين !'
                              : 'Fix your car now, pay later!',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFFBA1B1B),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Graphik Arabic',
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: const Color(0xFFBA1B1B),
                          size: 28.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      isArabic
                          ? 'تقسيط خدمات المركز'
                          : 'Installment for center services',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color:Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withOpacity(0.7)
                            : Colors. white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Graphik Arabic',
                      ),
                    ),
                  ),
                  if (isExpanded) ...[
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        isArabic ? 'محتوي العرض !' : 'Offer Details!',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          fontFamily: 'Graphik Arabic',
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        isArabic
                            ? 'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة...'
                            : 'This is a sample text that can be replaced...',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black.withOpacity(0.7),
                          fontFamily: 'Graphik Arabic',
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        isArabic
                            ? 'ينتهي العرض في 15 نوفمبر 2025'
                            : 'Offer ends on Nov 15, 2025',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFFBA1B1B),
                          fontFamily: 'Graphik Arabic',
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBA1B1B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          onPressed: () {},
                          child: Text(
                            isArabic
                                ? 'استمتع بالعرض الآن'
                                : 'Enjoy the offer now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
