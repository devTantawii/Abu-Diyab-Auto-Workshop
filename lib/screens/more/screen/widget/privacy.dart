import 'package:abu_diyab_workshop/screens/more/screen/widget/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/language/locale.dart';
import '../../../profile/widget/ITN.dart';
import 'frequently_asked_questions.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
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
                        ? " الخصوصية"
                        : "Privacy ",
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            widget_ITN(
              text: 'سياسة الخصوصية',
              //  iconPath: 'assets/icons/edit.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                );
              },
            ),
            SizedBox(height: 20.h),
            widget_ITN(
              text:
              'الأسئلة الشائعة',
              //  iconPath: 'assets/icons/edit.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FrequentlyAskedQuestions()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
