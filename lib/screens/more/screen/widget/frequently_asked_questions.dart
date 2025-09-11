import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/language/locale.dart';

class FrequentlyAskedQuestions extends StatefulWidget {
  const FrequentlyAskedQuestions({super.key});

  @override
  State<FrequentlyAskedQuestions> createState() =>
      _FrequentlyAskedQuestionsState();
}

bool isExpanded = false;

class _FrequentlyAskedQuestionsState extends State<FrequentlyAskedQuestions> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isArabic = locale!.isDirectionRTL(context);

    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
      appBar: AppBar(
        toolbarHeight: 100.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: 130.h,
            padding: EdgeInsets.only(top: 20.h, right: 16.w, left: 16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    Theme.of(context).brightness == Brightness.light
                        ? [const Color(0xFFBA1B1B), const Color(0xFFD27A7A)]
                        : [const Color(0xFF690505), const Color(0xFF6F5252)],
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    locale!.isDirectionRTL(context)
                        ? 'الأسئلة الشائعة'
                        : "Frequently Asked Questions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
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
                    Row(
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            isArabic
                                ? 'ما هي الخدمات التي يقدمها المركز ؟'
                                : 'What services does the center provide?',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
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
                    if (isExpanded) ...[
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          isArabic
                              ? 'نحن نقدم خدمات شاملة تشمل: صيانة دورية،فحص كمبيوتر، تغييرزيت وفلاتر، فحص المكابح، إصلاح الأعطال الكهربائية والميكانيكية، صيانةنظام التكييف، برمجةمفاتيح وأنظمة.'
                              : 'We offer comprehensive services including: periodic maintenance, computer check-ups, oil and filter changes, brake inspections, electrical and mechanical repairs, air conditioning system maintenance, and key and system programming.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black.withOpacity(.5)
                                    : Colors.white.withOpacity(.5),
                            fontFamily: 'Graphik Arabic',
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                    ],
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
