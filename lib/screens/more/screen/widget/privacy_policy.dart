import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/language/locale.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

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
                colors: Theme.of(context).brightness == Brightness.light
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
                        ? "سياسة الخصوصية"
                        : "Privacy Policy",
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Text(
          // هنا تقدر تحط النصوص الطويلة اللي عايزها
          locale.isDirectionRTL(context)
              ? '''
هذا مثال على نص سياسة الخصوصية باللغة العربية. 
ممكن تضيف هنا أي كلام كتير فشخ، سواء فقرات طويلة أو شروط وسياسات أو أي تفاصيل.

- البند الأول: شرح السياسة.
- البند الثاني: جمع البيانات.
- البند الثالث: استخدام البيانات.
- البند الرابع: حماية المعلومات.

والموضوع مفتوح تضيف قد ما تحب من النصوص.
'''
              : '''
This is an example of Privacy Policy text in English. 
You can add here as much content as you want, long paragraphs, terms, conditions, or anything.

- Section 1: Policy Explanation.
- Section 2: Data Collection.
- Section 3: Data Usage.
- Section 4: Information Protection.

Feel free to expand this with unlimited text.
''',
          style: TextStyle(
            fontSize: 16.sp,
            height: 1.6, // مسافة بين السطور علشان النص يبقى مريح للقراءة
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
