import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/language/locale.dart';
import '../../../services/widgets/custom_app_bar.dart';
import '../../cubit/static_pages_cubit.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => StaticPagesCubit()..fetchStaticPages(),
      child: Scaffold(
        backgroundColor:
        Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFD27A7A)
            : const Color(0xFF6F5252),

        appBar: CustomGradientAppBar(
          title_ar: "سياسة الخصوصية",
          title_en: "Privacy Policy",
          onBack: () => Navigator.pop(context),
        ),

        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.sp),
              topRight: Radius.circular(15.sp),
            ),
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
          ),
          child: BlocBuilder<StaticPagesCubit, StaticPagesState>(
            builder: (context, state) {
              if (state is StaticPagesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is StaticPagesLoaded) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child:
                  Html(
                    data: state.pages.privacyPolicy ?? "",
                    style: {
                      "body": Style(
                        fontSize: FontSize.medium,
                        lineHeight: LineHeight.number(1.6),
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        textAlign: TextAlign.justify,
                      ),
                      "p": Style(
                        textAlign: TextAlign.justify,
                        margin: Margins.symmetric(vertical: 8),
                      ),
                      "h1": Style(
                        fontSize: FontSize.xxLarge,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        margin: Margins.only(bottom: 12),
                      ),
                      "h2": Style(
                        fontSize: FontSize.xLarge,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        margin: Margins.only(bottom: 10),
                      ),
                      "h3": Style(
                        fontSize: FontSize.large,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start,
                        margin: Margins.only(bottom: 8),
                      ),
                      "li": Style(
                        fontSize: FontSize.medium,
                        margin: Margins.only(bottom: 6),
                        textAlign: TextAlign.start,
                      ),
                      "ol": Style(margin: Margins.symmetric(vertical: 6)),
                      "ul": Style(margin: Margins.symmetric(vertical: 6)),
                      "span": Style(textAlign: TextAlign.justify),
                    },
                  )

                );
              } else if (state is StaticPagesError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
