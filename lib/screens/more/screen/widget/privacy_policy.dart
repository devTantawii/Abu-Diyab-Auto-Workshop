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
            color:
                Theme.of(context).brightness == Brightness.light
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
                  child: Column(
                    children: [
                      Text(
                        state.pages.privacyPolicy ?? "",
                        style: TextStyle(
                          fontSize: 16.sp,
                          height: 1.6,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Html(
                        data:
                            """ <h1>عنوان رئيسي</h1> <p>فقرة <b>بخط عريض</b> و <i>مائل</i>.</p> <ul> <li>أول عنصر</li> <li>تاني عنصر</li> </ul> <a href="https://flutter.dev">رابط لفلتر</a> <img src="https://via.placeholder.com/150" /> """,
                      ),
                      Html(
                        data: """
<h1><ul><li style="text-align: center;">h1</li></ul></h1>
<h2><ul><li>h2</li></ul></h2>
<h3><ol><li><span style="background-color: transparent; font-size: 0.875rem;">h3</span></li></ol></h3>
<h4><ol><li><span style="background-color: transparent; font-size: 0.875rem;">h4</span></li></ol></h4>
<p><ol><li><span style="background-color: transparent; font-size: 0.875rem;">per</span></li></ol></p>
<ol>
  <li><span style="background-color: transparent; font-size: 0.875rem;">hfs</span></li>
  <li style="text-align: center;"><span style="background-color: transparent; font-size: 0.875rem;">fsedf</span></li>
  <li style="text-align: left;"><span style="background-color: transparent; font-size: 0.875rem;">sf</span></li>
  <li><span style="background-color: transparent; font-size: 0.875rem;">sdf</span></li>
  <li><span style="background-color: transparent; font-size: 0.875rem;"><u>sdfe</u></span></li>
  <li><span style="background-color: transparent; font-size: 0.875rem;"><i>sdf</i></span></li>
</ol>
""",
                        style: {
                          "h1": Style(fontSize: FontSize.xxLarge, color: Colors.red),
                          "h2": Style(fontSize: FontSize.xLarge, color: Colors.blue),
                          "h3": Style(fontSize: FontSize.large),
                          "h4": Style(fontSize: FontSize.medium),
                          "p": Style(fontSize: FontSize.medium, lineHeight: LineHeight.number(1.6)),
                          "li": Style(fontSize: FontSize.medium, margin: Margins.only(bottom: 8)),
                        },
                      ),

                    ],
                  ),
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
