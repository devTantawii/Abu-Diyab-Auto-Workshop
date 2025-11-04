import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/language/locale.dart';
import '../../../widgets/app_bar_widget.dart';
import '../../../widgets/navigation.dart';
import '../../auth/cubit/login_cubit.dart';
import '../../auth/screen/login.dart';
import '../../main/screen/main_screen.dart';
import '../../services/widgets/custom_app_bar.dart';
import '../cubit/offers_cubit.dart';
import '../cubit/offers_state.dart';

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
      backgroundColor:
      //   Theme.of(context).brightness == Brightness.light
      //  ?
      Color(0xFFD27A7A)
      //  :  Color(0xFF6F5252)
      ,
      appBar:  CustomGradientAppBar(
        title_ar:  "العروض",
        title_en: " Offers",
        showBackIcon: false,

      ),
      body: Container(height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
          color:
          Theme.of(context).brightness == Brightness.light
              ? Colors.white: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Expanded(
                child: BlocProvider(
                  create: (context) => OffersCubit(dio: Dio())..fetchOffers(),
                  child: BlocBuilder<OffersCubit, OffersState>(
                    builder: (context, state) {
                      if (state is OffersLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is OffersLoaded) {
                        if (state.offers.isEmpty) {
                          return Center(
                            child: Text(
                              isArabic ? "لا توجد عروض متاحة" : "No offers available",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }

                        List<bool> isExpandedList = List.generate(state.offers.length, (_) => false);

                        return ListView.builder(
                          itemCount: state.offers.length,
                          itemBuilder: (context, index) {
                            final offer = state.offers[index];
                            final relatedName = offer.service?.name ?? offer.product?.name ?? '';
                            final relatedId = offer.service?.id ?? offer.product?.id ?? 0;

                            // تأكد من أن isExpandedList معرفة خارج الـ builder (مثلاً في الـ State)
                            // أو استخدم StatefulWidget بدلاً من StatefulBuilder إذا كان هناك مشكلة في الحالة

                            return StatefulBuilder(
                              builder: (context, setStateSB) {
                                final locale = AppLocalizations.of(context)!;
                                final isArabic = locale.isDirectionRTL(context);
                                final isDark = Theme.of(context).brightness == Brightness.dark;

                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(15.w),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                                          border: Border.all(color: const Color(0xFFAFAFAF)),
                                          borderRadius: BorderRadius.circular(15.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(isDark ? 0.3 : 0.15),
                                              blurRadius: 12.r,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // الصورة
                                            ClipRRect(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
                                              child: Image.network(
                                                offer.image,
                                                width: double.infinity,
                                                height: 140.h,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  height: 140.h,
                                                  color: Colors.grey[300],
                                                  child: Icon(Icons.broken_image, size: 50.sp, color: Colors.grey),
                                                ),
                                              ),
                                            ),

                                            // العنوان + زر التوسيع
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                              child: Row(
                                                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      offer.name,
                                                      style: TextStyle(
                                                        color: const Color(0xFFBA1B1B),
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Graphik Arabic',
                                                      ),
                                                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      isExpandedList[index]
                                                          ? Icons.keyboard_arrow_up
                                                          : Icons.keyboard_arrow_down,
                                                      color: const Color(0xFFBA1B1B),
                                                      size: 28.sp,
                                                    ),
                                                    onPressed: () {
                                                      setStateSB(() {
                                                        isExpandedList[index] = !isExpandedList[index];
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // اسم الخدمة/المنتج
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                                              child: Text(
                                                relatedName,
                                                style: TextStyle(
                                                  color: isDark ? Colors.white70 : Colors.black87,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Graphik Arabic',
                                                ),
                                                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                              ),
                                            ),

                                            // التفاصيل عند التوسيع
                                            if (isExpandedList[index]) ...[
                                              SizedBox(height: 12.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                                child: Text(
                                                  isArabic ? 'محتوى العرض!' : 'Offer Content!',
                                                  style: TextStyle(
                                                    color: isDark ? Colors.white : Colors.black,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Graphik Arabic',
                                                    height: 1.6,
                                                  ),
                                                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                                ),
                                              ),
                                              SizedBox(height: 6.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                                child: Text(
                                                  offer.description,
                                                  style: TextStyle(
                                                    color: isDark ? Colors.white70 : const Color(0xFF474747),
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Graphik Arabic',
                                                    height: 1.5,
                                                  ),
                                                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                                ),
                                              ),
                                              SizedBox(height: 6.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                                child: Text(
                                                  isArabic
                                                      ? 'ينتهي العرض في ${offer.expiredAt}'
                                                      : 'Offer expires on ${offer.expiredAt}',
                                                  style: TextStyle(
                                                    color: const Color(0xFFBA1B1B),
                                                    fontSize: 12.sp,
                                                    fontFamily: 'Graphik Arabic',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                                ),
                                              ),
                                              SizedBox(height: 16.h),

                                              // زر "استمتع بالعرض"
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFFBA1B1B),
                                                      foregroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(15.r),
                                                      ),
                                                      padding: EdgeInsets.symmetric(vertical: 14.h),
                                                      elevation: 2,
                                                    ),
                                                    onPressed: () async {
                                                      final prefs = await SharedPreferences.getInstance();
                                                      final token = prefs.getString('token');

                                                      if (token != null && token.isNotEmpty) {
                                                        final slug = offer.service?.slug ?? offer.product?.slug ?? '';
                                                        final title = offer.service?.name ?? offer.product?.name ?? '';
                                                        final description = offer.service?.description ?? offer.product?.description ?? '';
                                                        final imagePath = offer.service?.icon ?? offer.product?.icon ?? '';

                                                        navigateToServiceScreen(
                                                          context,
                                                          slug,
                                                          title,
                                                          description,
                                                          imagePath,
                                                        );
                                                      } else {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          isScrollControlled: true,
                                                          backgroundColor: Colors.transparent,
                                                          builder: (_) => FractionallySizedBox(
                                                            widthFactor: 1,
                                                            child: BlocProvider(
                                                              create: (_) => LoginCubit(dio: Dio()),
                                                              child: const LoginBottomSheet(),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      isArabic ? 'استمتع بالعرض الآن' : 'Enjoy the offer now',
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Graphik Arabic',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],

                                            SizedBox(height: 12.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                  ],
                                );
                              },
                            );
                          },
                        );                      } else if (state is OffersError) {
                        return Center(
                          child: Text(
                            isArabic ? "لا توجد عروض متاحة" : "No offers available",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
/*
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
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
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black.withOpacity(0.7)
                                : Colors.white,
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
       */