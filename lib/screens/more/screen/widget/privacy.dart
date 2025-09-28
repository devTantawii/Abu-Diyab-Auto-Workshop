import 'package:abu_diyab_workshop/screens/more/screen/widget/privacy_policy.dart';
import 'package:abu_diyab_workshop/screens/more/screen/widget/tax-certificate.dart';
import 'package:abu_diyab_workshop/screens/more/screen/widget/terms%20and%20conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/language/locale.dart';
import '../../../profile/widget/ITN.dart';
import '../../../services/widgets/Service-Custom-AppBar.dart';
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
          ? Color(0xFFD27A7A)
          : const Color(0xFF6F5252),
      appBar:  CustomGradientAppBar(
        title_ar:  "الخصوصية",
        title_en: "Privacy",
        onBack: () => Navigator.pop(context),
      ),
      body: Container(
        height: double.infinity,
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
              SizedBox(height: 20.h),

              widget_ITN(
                text: 'الشروط والأحكام',
                //  iconPath: 'assets/icons/edit.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsAndConditions()),
                  );
                },
              ),
              SizedBox(height: 20.h),

              widget_ITN(
                text: 'الشهادة الضريبية',
                //  iconPath: 'assets/icons/edit.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tax_Certificate()),

                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
